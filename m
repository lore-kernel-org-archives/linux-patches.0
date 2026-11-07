Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061929;
	b=Ud44jE4wUT159t3ogB7aglavCIn5AHw0l3bquMPDTpfvzwl4dEEcTJvN1HzVlKlksTYn
	 X0/HGtCxSE6Q7DgcF47RUzj8R1bPt9qYZykXn5GlSRnS8xcKauUUpU34LEQZBaGcZ397n
	 SB8Inlcx7GAQnEK+OXX/rvD7xsPHv/XyPCuKpGg1FVR5NBGKaRrACJQSxFRuefPqqHH1n
	 jo/kqYpViTMXz6cZsjjPcnsMWnWyrOQc3kXoF4el58kOOtpzGjW1fcIeCpUtaLoy6qMiC
	 GGxnb3A2Nfa2Ww0EmCtbeKWKIMCgxzz/LOtAA5ys9uvm5o/fU1NwZ4YAen0W3+fDRpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8q6TIBBAFibkI72++/TM94QjPdZw7A+xvBW9puCOCpk=;
	b=NSuhsl6wo+eYHKxktvbmEDpCCXbqLGf4BvmA3K9ECPv8sT4qrMJQLPTI2e7OPfhD5K7S
	 zn70a/cIlUuNSQfu8HKQ++X6eRv6TYBCVqRcqagfjjUGFzZTW2axM6QLm3nfyHMRC72O3
	 njdFzHtWI4+YHK56ZfPtgF5UTjU+1M8iYBCaJ8o5leo9RMeP7R5OD8sUG9zXy1Pwzc0h2
	 NQnCSKWahMfZPGjmFbTD0iib8I8x5+V3m7vB4SgTeX01F+8zJ7eeeb8qdP+echAPUUpkg
	 MGEgYcCzrOn2oqDyqj74kTQdN196ERVsHXeuM9FGssc8ZZC2UYT7iTv7iLDXlJQ1GvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JBjg4QKH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E52606A330;
	Sat,  7 Nov 2026 14:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JBjg4QKH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED641F0089F;
	Sat,  7 Nov 2026 14:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061928;
	bh=8q6TIBBAFibkI72++/TM94QjPdZw7A+xvBW9puCOCpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JBjg4QKHXJC3Gg1rm82vYwfl12bkggQKqmDA6RTyjKAVh2PLu8vub+BzQSN7goXEW
	 BlINEEqU5koDoU5Hzi1axDbhn4WPO2Zhp07KomM3vlmPR8oONIOptJ6PfgBZUZo9ms
	 nMneJ16t1lSUy/s45hJTfPZj6aBaEtGpvxeIyp+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0933/1536] firewire: core: fix source bus ID detection for AT context in big-endian systems
Date: Sat,  7 Nov 2026 08:49:09 -0500
Message-ID: <20261107135023.853557157@linuxfoundation.org>
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 6393d75914a6ac95a05621db8d9d6a98eafe72f7 ]

The source bus ID bit in AT DMA context is not detected correctly on
big-endian systems because the little-endian data is not converted to
CPU endianness.

Fix the bug. The helper functions related to this are never used in
driver code, so extend the test to check the field instead.

Cc: stable@vger.kernel.org # v6.12
Fixes: 8db9d1557122 ("firewire: ohci: add static inline functions to serialize/deserialize data of AT DMA")
Link: https://lore.kernel.org/r/20260908122840.2886621-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/ohci-serdes-test.c | 4 ++--
 drivers/firewire/ohci.h             | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/ohci-serdes-test.c b/drivers/firewire/ohci-serdes-test.c
index 258f668619ef1..87b136e041de3 100644
--- a/drivers/firewire/ohci-serdes-test.c
+++ b/drivers/firewire/ohci-serdes-test.c
@@ -43,7 +43,7 @@ static void test_self_id_receive_buffer_deserialization(struct kunit *test)
 static void test_at_data_serdes(struct kunit *test)
 {
 	static const __le32 expected[] = {
-		cpu_to_le32(0x00020e80),
+		cpu_to_le32(0x00820e80),
 		cpu_to_le32(0xffc2ffff),
 		cpu_to_le32(0xe0000000),
 	};
@@ -56,7 +56,7 @@ static void test_at_data_serdes(struct kunit *test)
 	unsigned int destination_id = ohci1394_at_data_get_destination_id(expected);
 	u64 destination_offset = ohci1394_at_data_get_destination_offset(expected);
 
-	KUNIT_EXPECT_FALSE(test, has_src_bus_id);
+	KUNIT_EXPECT_TRUE(test, has_src_bus_id);
 	KUNIT_EXPECT_EQ(test, 0x02, speed);
 	KUNIT_EXPECT_EQ(test, 0x03, tlabel);
 	KUNIT_EXPECT_EQ(test, 0x02, retry);
diff --git a/drivers/firewire/ohci.h b/drivers/firewire/ohci.h
index 218666cfe14a5..63ccf2f445045 100644
--- a/drivers/firewire/ohci.h
+++ b/drivers/firewire/ohci.h
@@ -178,7 +178,7 @@
 
 static inline bool ohci1394_at_data_get_src_bus_id(const __le32 *data)
 {
-	return !!((data[0] & OHCI1394_AT_DATA_Q0_srcBusID_MASK) >> OHCI1394_AT_DATA_Q0_srcBusID_SHIFT);
+	return !!((le32_to_cpu(data[0]) & OHCI1394_AT_DATA_Q0_srcBusID_MASK) >> OHCI1394_AT_DATA_Q0_srcBusID_SHIFT);
 }
 
 static inline void ohci1394_at_data_set_src_bus_id(__le32 *data, bool src_bus_id)
-- 
2.53.0



