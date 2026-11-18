Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020007;
	b=F708GbYscmKHza94vc61cW+cL/hrOZxKwrNbu8KkYuatC7rElhCb1pjQlju7fKMsAi2f
	 gfYtVt+3AUuzDF6AsKqUenPOaiAflfBgHBL/I6wZDyaFclpffF9xtPEkWs59i01jekO72
	 up+taMdOmAa2dnbl0fIcwqItjwP0iK7kJvE4+AKSgTgFdYG9gQncqr8woHDho8Lc0g8us
	 Ohx0Ayxrw0eo8MvxcX70o7/BhI2o8ld8SgGzw71ksKXpEf1hdH3GTFf1F0BOBb3jn9eWn
	 uYcQktR3V2L+sJd7T0WND+1akoTfLzIcwXBgDnnipg1XfQs0GjHdw2/PbuTE7H8s7Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7RICqZukYTZSJR6/7rbuvg8BzM0JZquf7UNSxonyvRw=;
	b=5f/z6yT/qEQ1eROOsmfgrQZTVHSJMk1rscFfILyuTBw5MlJFBoH5j/8x2QSHR3hMksSu
	 vW2K8qf2nLC7qErQ29Qjxy5ezP7Bb1CIGvF0ypMpAaI1HWsgnyCGAf5oaOesaUOMUNN0Y
	 9casAdPdFaROcDtlQFi9CWh6BNTOHGBSEuOOTeTr4vLraLvAtictNeZAdzAJEWI/gaZm4
	 wPaUkNl0EC58iyo+5Xt2lOw1byxX7cyVcQumS2oymxPKUrPC/wZBbEMAjbhRmtiXidKCg
	 3llCLXTy1T7ktaRYaWKAnW9wULu6fT9xIFDwqv6QEwhjoOfNsI4/RTLNyTW5nCgL1ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dRuKIcdT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B77F606A31C;
	Wed, 18 Nov 2026 16:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dRuKIcdT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AE81F000C6;
	Wed, 18 Nov 2026 16:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020007;
	bh=7RICqZukYTZSJR6/7rbuvg8BzM0JZquf7UNSxonyvRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dRuKIcdTWPaRzk3cOqTIgR/W3lxcJzVlNwu6hijnswTQB3LqnmH3O//sqSkeoSd0d
	 gqvb2jv2ZF4vlaOMpwg3driHygnw1ivKDtTY2yeyd8LuGo7QGzhcYw+a/hAfLaagqP
	 7ELFrBxrEVvI4KZF+eeRJWKVYa/o6KCxswaWcflw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1799/2651] sh: sh7785lcr: Register the PCA9564 controller as I2C bus 0
Date: Wed, 18 Nov 2026 15:50:39 +0100
Message-ID: <20261118150352.067561361@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 3b8386ffc0c33b6b5a6a8e64e1487c1adec57dc9 ]

Before commit 44454baa7ca7 ("i2c: Dynamically assign adapter id if it
wasn't explictly specified"), a negative ID was replaced by zero, and
I2C bus zero was instantiated. Since that commit, a negative ID is passed
verbatim, instantiating an I2C bus with a dynamic number. As SH boards
still use i2c_register_board_info(0, ...) to register I2C devices, they
rely on the I2C bus being bus zero.

The SH7785LCR is the only SH board whose I2C adapter has a negative ID
and its PCA9564 controller becomes i2c-1, causing registration of the
R2025S/D RTC to fail and hwclock not detecting /dev/rtc0.

Set the platform device ID to 0 so that the adapter is registered as
bus zero again.

Fixes: 44454baa7ca7 ("i2c: Dynamically assign adapter id if it wasn't explictly specified")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Assisted-by: LLM
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/boards/board-sh7785lcr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/boards/board-sh7785lcr.c b/arch/sh/boards/board-sh7785lcr.c
index 25c4968f0d8b0..b93423df582f7 100644
--- a/arch/sh/boards/board-sh7785lcr.c
+++ b/arch/sh/boards/board-sh7785lcr.c
@@ -256,7 +256,7 @@ static struct i2c_pca9564_pf_platform_data i2c_platform_data = {
 
 static struct platform_device i2c_device = {
 	.name		= "i2c-pca-platform",
-	.id		= -1,
+	.id		= 0,
 	.dev		= {
 		.platform_data	= &i2c_platform_data,
 	},
-- 
2.53.0



