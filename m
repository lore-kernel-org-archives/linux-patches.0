Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06BA1DE8A5;
	Tue,  3 Dec 2024 15:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241502; cv=none; b=kQrmQpnsbdkcI00JXnM5p0MiqR3e4cT0FryFjQLR9WfILao+2MTDYuahTyM1pGSdDqmclu+rtpUzEinAs1F10Wigj+tkjFWCNZFyH0m/Y1PAj2YpavVQ1sidFBJWVy+m5rOSD6QfByGHZrlC7Tm5HXGgK82QqkN1YF/Q4HMUJ6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241502; c=relaxed/simple;
	bh=zk9vYDpiQrwya0wsPNeRuDGuGH14Pnf2PAK3kv6CIpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaLKPjDcZ/P/w3dejVQZbJhqVP7MAGyCF4Ui8qaEGA6z1/8Mxr+b6H/QAyaTTRlrl04QmEYQwriBSiJ+4SevN2X9mxMkgeL+4qADnrOd9D2NPUsICCdRmUo4IbmFMlQoQMhhPXPVJ9xdN5hH7rRfAXKcQuSPLN13wGxvUIR8PnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H4h+5h1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H4h+5h1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD5DC4CECF;
	Tue,  3 Dec 2024 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241502;
	bh=zk9vYDpiQrwya0wsPNeRuDGuGH14Pnf2PAK3kv6CIpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4h+5h1+iJ160wNiNJ8dDcKrHKgYEMgjwS+IbVzAPDBHGqnuLjv59Yd+h0EeJT0rd
	 Dji5dh9YSf5Yk728dXTXgUcwrHYVX3l7B6NDoQ3dTGzuqJ/Ww//Qyhl0a037Mnth4Q
	 gFrdi5mjhz/PRGre4CF8ShMHgbD4CTQ8P5UbWtuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 436/826] zram: ZRAM_DEF_COMP should depend on ZRAM
Date: Tue,  3 Dec 2024 15:42:43 +0100
Message-ID: <20241203144800.770573442@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 9f3310ccc71efff041fed3f8be5ad19b0feab30b ]

When Compressed RAM block device support is disabled, the
CONFIG_ZRAM_DEF_COMP symbol still ends up in the generated config file:

    CONFIG_ZRAM_DEF_COMP="unset-value"

While this causes no real harm, avoid polluting the config file by
adding a dependency on ZRAM.

Link: https://lkml.kernel.org/r/64e05bad68a9bd5cc322efd114a04d25de525940.1730807319.git.geert@linux-m68k.org
Fixes: 917a59e81c34 ("zram: introduce custom comp backends API")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
index 6aea609b795c2..402b7b1758632 100644
--- a/drivers/block/zram/Kconfig
+++ b/drivers/block/zram/Kconfig
@@ -94,6 +94,7 @@ endchoice
 
 config ZRAM_DEF_COMP
 	string
+	depends on ZRAM
 	default "lzo-rle" if ZRAM_DEF_COMP_LZORLE
 	default "lzo" if ZRAM_DEF_COMP_LZO
 	default "lz4" if ZRAM_DEF_COMP_LZ4
-- 
2.43.0



