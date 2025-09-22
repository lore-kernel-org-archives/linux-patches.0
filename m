Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021E82F39DE;
	Mon, 22 Sep 2025 19:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570290; cv=none; b=e50UBz6hxk+qtTVWGQyz8ZqeobKuAlupUyeTYSdPRKgz25+mX/qoEoHsB+6RID9jWUXq7Zs5mtEy2NuhIZUYg2+J4sseCCbAfm7fNmnyK0xK9yWtmPhRT1CHXdhD3djOrdAMcj7uOiJ1ZWTJJA2kpDmn19wwpe/Zw5umxaJCmMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570290; c=relaxed/simple;
	bh=M3tpF8wx2xd63x74Glv7tAmANgrJRDYh4tJi7EqBKiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovAYfGmtAKuKLn8A6bqxkSkYUNvTGgUYgTxxMv+Q9wH3KPlq5v9LUu8NHuarVXq3l0at1ffhXXlKmwy5qfwimmnirjAxzBDKNJtKUNxk6etK5jkSKNlnPw283li+YG8qDF5PqCyHvyNL8SHkpQxjg2duyUzWlJtwQU0lruBLCn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWbGGHe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWbGGHe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C4DC4CEF0;
	Mon, 22 Sep 2025 19:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570289;
	bh=M3tpF8wx2xd63x74Glv7tAmANgrJRDYh4tJi7EqBKiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWbGGHe9IdR17KqZecf9nUtbsZTy3dR/hZHU33i7FdLP/E52IwlKUY2zeEG5jcmY6
	 kvoyHwcUyEGw8tCE/fuctqoY67t+cQZf44/Ct+eVV0t0FtRT6q+b/+J0dxtFsvv9F5
	 xXrQSA1FOLwtdHJFwcdzwO7X+GVCw+TlYIFCkWtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Chuang <ben.chuang@genesyslogic.com.tw>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.16 091/149] mmc: sdhci-uhs2: Fix calling incorrect sdhci_set_clock() function
Date: Mon, 22 Sep 2025 21:29:51 +0200
Message-ID: <20250922192415.180372768@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Chuang <ben.chuang@genesyslogic.com.tw>

commit 09c2b628f6403ad467fc73326a50020590603871 upstream.

Fix calling incorrect sdhci_set_clock() in __sdhci_uhs2_set_ios() when the
vendor defines its own sdhci_set_clock().

Fixes: 10c8298a052b ("mmc: sdhci-uhs2: add set_ios()")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-uhs2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-uhs2.c
+++ b/drivers/mmc/host/sdhci-uhs2.c
@@ -295,7 +295,7 @@ static void __sdhci_uhs2_set_ios(struct
 	else
 		sdhci_uhs2_set_power(host, ios->power_mode, ios->vdd);
 
-	sdhci_set_clock(host, ios->clock);
+	host->ops->set_clock(host, ios->clock);
 	host->clock = ios->clock;
 }
 


