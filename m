Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8D230FC1C;
	Wed,  3 Dec 2025 15:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776320; cv=none; b=BJLxW+XACyIq8V/Qm0CVZPVkx43FwOPbsYeeoF/UZEmpGbRRyz0E6jpT7wJqtv6efNVgBeshdPUneR77Jr60/7wOXL02900BV9JHNxx+hgSWP+LcBx56348Jz+0GuQ221iR2DF/9iADtpXADGQNiV7R28IMhXFB0O/vXcMxAdOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776320; c=relaxed/simple;
	bh=ukPDtM3v+k1rmtB4KdoDi+PND/LhgcvKs0zV7Tf0OZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyeNXViQQ3RPekzTv2oT9XBW3k7FG226vCiOn2iVEwe5grZ5Bpukv+7acvFakH8NAKoayPykswx4mIFj7tNjCYLV+4gsKmU1+n8iXioHx2PPucAXqPW9JH1bo3sN8X+EPJYmQvwJt33nTt+4PyF3W+F2+QTTi+idKAuHCXjCA04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kf6Un2F/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kf6Un2F/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB3DC4CEF5;
	Wed,  3 Dec 2025 15:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776320;
	bh=ukPDtM3v+k1rmtB4KdoDi+PND/LhgcvKs0zV7Tf0OZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kf6Un2F/LMJzBQAQsFdZC8YYfuIJ3TC9dVK9osduqRT/H51iRUF1o82r72eFTvI3B
	 3CnaT0wAbN6Owd6k6qhjfihgZt1U0OI9zH2d44YK10DAtWtVKK+SdG9e3v8hCGt5Aa
	 xAKyy3QC5toQoVChaiNw9PyMormfTOWD/XoErLhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/300] um: Fix help message for ssl-non-raw
Date: Wed,  3 Dec 2025 16:25:52 +0100
Message-ID: <20251203152406.100921875@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 725e9d81868fcedaeef775948e699955b01631ae ]

Add the missing option name in the help message. Additionally,
switch to __uml_help(), because this is a global option rather
than a per-channel option.

Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/ssl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index 6476b28d7c5ec..63da74e3f2776 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -202,4 +202,7 @@ static int ssl_non_raw_setup(char *str)
 	return 1;
 }
 __setup("ssl-non-raw", ssl_non_raw_setup);
-__channel_help(ssl_non_raw_setup, "set serial lines to non-raw mode");
+__uml_help(ssl_non_raw_setup,
+"ssl-non-raw\n"
+"    Set serial lines to non-raw mode.\n\n"
+);
-- 
2.51.0



