Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060718;
	b=Ry52M7Qak0bI8oByS9fgGTRdgYU8yep8sBIa6bNTibwflviNMdKGrq/Kc7j4GMBhDj7d
	 bL+Y6D950dBFzbaCR/PTTCMa9+Hs13DFZoVjfPrMYIyEQBVTgnTQKrO/8iyvjjcM7LiGt
	 I82S5kM3DGEwQaCvj14KMn7lsZcLq5YY4HakFoxN/x/SaXdqUV2mOrQN2qrU1O6edsGZ0
	 G9VWhBOa1LB4OleELbsjIWXsU9drOh7nMb1AtWsF2tNmrXEgjJ0Faze3gJKL/kA3Xq/IU
	 9nVlJCltMKuXeFDpjdK4FBIYaHot7adNZEbJlYL8FDzCy5YCPPJhCFwE2wRJOGmFCtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lKpK6rkbrGV1lxXLgnssqa6xAefY5WJbT0Q0AtIsPB8=;
	b=Cpae+AwgaLAy5SXSDtj7x6CjDyBv/fgfSgxaQkj60CDmZsC9s3UdHKq8c15QFHE9XE6O
	 8JWnMRRCkTyUv/e0jahx1HzvV7T6l2cgnjdib3JXOwxwldplsqHfRnfR0z8lKQXCMBKUP
	 MnFdHjVhg6XJaR4n1swjlN5KwZS/9bE1OkDumtpfJ67giaNJTmoXjTSjBObt/zb2rQsKw
	 4icTFTgwcNmU1ppk1ZU3rJUsToFiNY3aPrtHV6DteLTuudMG+4FSgR/ixoCZxQfpwjJIv
	 +/HpkOx+jIh+3ej1+7EReKsP/cUl6leA5QowUNqJajjyPQxyn1WuGs9Zte9J21h4wSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F2wrxw2O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594FA606A326;
	Sat,  7 Nov 2026 14:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F2wrxw2O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2A51F0089F;
	Sat,  7 Nov 2026 14:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060717;
	bh=lKpK6rkbrGV1lxXLgnssqa6xAefY5WJbT0Q0AtIsPB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2wrxw2O9BEsBVw+p6JXEowrdhnSzGByzul45tEp2b3wAwFeOu4GH0YIBLgewsaeQ
	 5D0mpvKGhzdX6tehSjfEg4l+eMnCVPZ+Rlhc19VCIAZtbpO2dvnveNtUYHVMzU8CmA
	 UzE2ELWQO2CJkqXEfw8ROYUY90F3wJIOBIW4cCOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0123/1536] soundwire: intel_auxdevice: Add cs42l44 to wake_capable_list
Date: Sat,  7 Nov 2026 08:35:39 -0500
Message-ID: <20261107135001.139131706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit d08e4d9197396ceb906715d976b63aed0c5cc8e5 ]

Add cs42l44 to the wake_capable_list because it can generate
jack events whilst the bus is stopped.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260708122948.1502227-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel_auxdevice.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soundwire/intel_auxdevice.c b/drivers/soundwire/intel_auxdevice.c
index ae1dfce163e25..d444ca477064f 100644
--- a/drivers/soundwire/intel_auxdevice.c
+++ b/drivers/soundwire/intel_auxdevice.c
@@ -50,6 +50,7 @@ static struct wake_capable_part wake_capable_list[] = {
 	{0x01fa, 0x2A30},
 	{0x01fa, 0x2A3B},
 	{0x01fa, 0x4243},
+	{0x01fa, 0x4244},
 	{0x01fa, 0x4245},
 	{0x025d, 0x5682},
 	{0x025d, 0x700},
-- 
2.53.0



