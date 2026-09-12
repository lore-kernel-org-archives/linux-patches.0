Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD545426EBB;
	Sat, 12 Sep 2026 10:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208166; cv=none; b=lq7KBTqOdOJ5MCwdKPAiDKPwqklCbx/u5ZZVlmz9laZ8xH5H1jTW7VXM/EJhn2oSj2XP1uYwE9FJjk1DKjFB0cs8R8dPAQKsrh/a+r/QHYUnCVupLYvM7yqWoz/nKXlfHy7k1ZnU5QE/ShG87E6R8hUKoA0TlTBdOcT400Uuz4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208166; c=relaxed/simple;
	bh=k+aRM/nHKPSYIEA98pNJSMuPsbPeLzbecABC5N6zYTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIdl+g6mufnO4eUsJwJCdDV9ZQuExnrNXH8RjQoqt0JV/TnSipsmICQ0IDmuddW6J0KL3HDq3Q6S8H7ChW84cTwAxzCkCtYid2Z1HYs4wW352MGuIHw7tS8YSZY1GU3qc0qyv1j+GSXs0Z8b+oEoclXOP6J4Vx4PbhqOMheZz7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uha5Eq2N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uha5Eq2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7261F000FF;
	Sat, 12 Sep 2026 10:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208163;
	bh=I6TUsFGyNQUczlzuY/n9GhPPBZoE3fAsSLsjRjfoWiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uha5Eq2Nc/5/INxeGwzhoB4afTAmHY5g5uLzw0KvNcFDkKVPd9c60f1L4tn063QqN
	 GqY/qGxqjUm3Cfg5hI66+nRisI+9Hx4BHixA88Ugdn8SxSdbUUGWbcDdwBPpvHfp8i
	 WhdOfEKhNTG2RNCIgF0PmCP7/txgBluC9uDdlNuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0563/1518] drm/tve200: add OF module alias for autoloading
Date: Sat, 12 Sep 2026 08:45:32 +0200
Message-ID: <20260912065636.169389423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit b6c3585f2058e0fbfa8cb403458f5cc6cf5c5e06 ]

The TVE200 DRM driver can be built as a module and uses tve200_of_match
as its OF match table, but the table is not exported for module alias
generation.

Add the MODULE_DEVICE_TABLE(of, ...) entry so modpost can generate OF
module aliases for OF based module autoloading.

Fixes: 179c02fe90a4 ("drm/tve200: Add new driver for TVE200")
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260715024130.186416-1-pengcan@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tve200/tve200_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tve200/tve200_drv.c b/drivers/gpu/drm/tve200/tve200_drv.c
index a048e37f1c2c1..7d0329292ef6d 100644
--- a/drivers/gpu/drm/tve200/tve200_drv.c
+++ b/drivers/gpu/drm/tve200/tve200_drv.c
@@ -259,6 +259,7 @@ static const struct of_device_id tve200_of_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, tve200_of_match);
 
 static struct platform_driver tve200_driver = {
 	.driver = {
-- 
2.53.0



