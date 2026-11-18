Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061687;
	b=5MHwv9kakBSE2xiVW7NPdgFNJTUaRJi9WsDnifpvcmayPfddVRqSfGvniRneo+Z7H3qD
	 RhqAMgGdEt2nE8pHPwYsuOnc3MdCc0J0xcWlM8E673zrgkBMXUAXbDcSFkxObidS4ZBRs
	 mAqdXLLTO5g0FVBQCv7IsftGIdOJSzp0vfQJNmDXhh4tQgmu0OEieZINubSqPWGHuJa4M
	 niD6U1WtBwM3wW31Ldp4+bQwgc8Svpqx2hjpCtPqp4NSEcgeSyujWzfaz1CzrmAF6ZPrv
	 uIrJ4zTmSw/r7WiT709O1gmOXeSA2EC61vDEOuaJeU3RyrfccSJJV1lyDaUjN6cf0PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W4NHilHWTjFKoyy7u1DqiFFoiqnTLHbmEo0AyU3HL+c=;
	b=AZg84dkIJpjXYetmb+juGIHnOwFefk0pyjNaKyHP/EY/dwrQCTUQ5htlWaK8mn+MI7gS
	 ZErI13VV71IVD+fWo3j3bh+YgMC/D8nz546upt0vnBxa7xWXgXWotOYszX4yEQIywTdhQ
	 X8oWM7MHzU4VCmWvrq+93BUXvgK06Zzwj2TNPrfeQn3MYwjsX5DhgDK1RXlptL1g5UQyq
	 o95eei4Tf2K8qGL01uzFc6VScUBUFxRGfAJBUzk62jyivza0OfywaZYflRU1s6Zch2ya8
	 G8NJ82cTCinlCqwRJuVRhZrlTrLs9YTHG3DW8o0kHNwwoB0hjPGPCZiYouY3USjmFsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G9iQ3sCc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A303606A325;
	Thu, 19 Nov 2026 04:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G9iQ3sCc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91C91F000C4;
	Thu, 19 Nov 2026 04:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061687;
	bh=W4NHilHWTjFKoyy7u1DqiFFoiqnTLHbmEo0AyU3HL+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G9iQ3sCcsx7WChCKRstMgYlQoju0RfBZBKDUt5bB/6PhmVnNcQqGq3Zm9o3ilnnZY
	 IX005tacNZY4eX5VlTgSr2up9mR0LUjy12OdbnjusyU13Ehr+PaK9DFeRnWNAdbipg
	 xdV1g0Cr882LfqxXNHjHtH0T7mfitX8JfTfqMQak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1601/1848] bus: arm-cci: Drop CPU node reference in cci_ace_init_ports()
Date: Wed, 18 Nov 2026 16:00:39 +0100
Message-ID: <20261118150026.485028087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit 41d6c0fcd4d75bf78c304c6660d60fcf757885ce ]

cci_ace_init_ports() looks up each possible CPU's node with
of_get_cpu_node(), which returns the node with its reference count
raised, but never releases it: neither when the CPU has no ACE port nor
after the port has been recorded.  Before the commit below the loop used
for_each_child_of_node(), which manages the references itself.

The node is only needed for the port lookup, so drop the reference right
after __cci_ace_get_port().

Fixes: 78b4d6e0fd26 ("drivers/bus: arm-cci: avoid parsing DT for cpu device nodes")
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Link: https://lore.kernel.org/r/20260923163536.596107-1-oss.patchbox@gmail.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/arm-cci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
index b8184a9035837..ab9b49451f8f2 100644
--- a/drivers/bus/arm-cci.c
+++ b/drivers/bus/arm-cci.c
@@ -199,6 +199,7 @@ static void cci_ace_init_ports(void)
 			continue;
 
 		port = __cci_ace_get_port(cpun, ACE_PORT);
+		of_node_put(cpun);
 		if (port < 0)
 			continue;
 
-- 
2.53.0



