Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829466;
	b=tUYU/ktoQfQHrS0uVF2Z3yVN/kFGBd4a0GUy2V19+MzoAPYVUfAjM5SOCoy0MW4mekDi
	 0nZuoh5gU7c8jf3rHT8HCZvm+9xaLJZNfWDZuOWBQboD4ciT5GbqD0GADTgwBTOnszO0y
	 VfhC8U0r1/N280gvawGUd3U2Ynf+28etFNl3D0AuXe4YWAppCn1lCtzEGUNGYJKZ9764r
	 0SG1GlqtMdKX+EkLSDQPdpgU3OGiNrGcq3aXEkCvjSo5jza9s8aCEEYmc5z7nd4Ik5heo
	 KvH1RASO8ShWqYRLpSqMnX9OaV1ytNLgwMexqfj+2cyDKs9kLtaJL/gcW7eE5GcIMKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2co+2iUh1mb5FGy0f8OJelxOtfsY2/Emc2RajrmmY0s=;
	b=Q67s8YjEL5sOlvuHTNvPeRJwnjoODj4u6W8E7szg5c73ML0sk7eNKk6MkGgIPR8EZ47I
	 kiaHB1EfFVaDANu8SqJa14aPpPQzU7P5eDK+HavrL3lhjTGbCo6kRmI8NUIaWVsErlx3o
	 bXeRfXdeOsn4WYhatCAs8O0wTMtTY4Cx++MTx0eufA1/sg0q4QHgGAFaxXX7AxvsqZHMH
	 or32T9iPuNfzqJ/Qd2hk4cnVsIrsXcN7lLvJFSiVw0xfqENvqyCx9hxT/ihMNSL4um++q
	 1tiPbiZufXDXpqHjoKd9pvstAE+ucTfMXBceQIr0rceaUNJy1EoEaBXOW4qQIRY5hzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ouNLs8CS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AB5606AB0B;
	Wed,  4 Nov 2026 21:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ouNLs8CS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E321F00A17;
	Wed,  4 Nov 2026 21:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829465;
	bh=2co+2iUh1mb5FGy0f8OJelxOtfsY2/Emc2RajrmmY0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ouNLs8CSgcyOV2jJ5l1kRzFExtLuVqVnqie9A+ghQQdDBALE1W00hhiTOS9us1ea+
	 SeW6nfbXYn54TlrPlXiWMv5gUHPnn1nOuIx48dJdG4bonyY55/GszTsqsAV3c+G3aQ
	 0xfkyj0H7nk1VG53zXJXgixHbe9XIkIYBt9lwMBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0143/1005] soundwire: intel_auxdevice: Add cs42l44 to wake_capable_list
Date: Wed,  4 Nov 2026 15:57:56 -0500
Message-ID: <20261104211047.708549536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c0c8ffcecc6bf..347e06ad6edba 100644
--- a/drivers/soundwire/intel_auxdevice.c
+++ b/drivers/soundwire/intel_auxdevice.c
@@ -54,6 +54,7 @@ static struct wake_capable_part wake_capable_list[] = {
 	{0x01fa, 0x2A30},
 	{0x01fa, 0x2A3B},
 	{0x01fa, 0x4243},
+	{0x01fa, 0x4244},
 	{0x01fa, 0x4245},
 	{0x025d, 0x5682},
 	{0x025d, 0x700},
-- 
2.53.0



