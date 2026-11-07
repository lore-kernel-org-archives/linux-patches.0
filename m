Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063937;
	b=ssOJ3dhtAjlBP4uymPtO26+KMn5QQ/4x0zQYvko7bq9UeprCHNElH089ppCTSQShTVnA
	 Smz17JC9IKFXzXrvH9bPMNnqmsAlJfEZFaw8pvF9bPVNAOQOahobsP3Vubm+H5U3nHiBK
	 ZwfxC5CtjmaKaBKbXsGm/gpWs/CeMHuFixsI2z4bqmyl7ILSpyW4nglDoNQeydfrlh/aI
	 2O7gYDwlBQDi77b6ifN/AzxFlbNoCSP3xlwBgMDuixL+13U7MSn/wpfenSnNUXSFrZRdK
	 DNk7bBEDz56NbFXqLK0EiVcVpMpyL0UdJLLqtj8Yw/5De1/WwfDYqNq9bPyweRR9znQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nQvUkd0DSG8BzRzeXh4AMOPYWuo4xyEvZ9X+UF1DkNk=;
	b=VUmT+pCw9z96NXICViBRqHPItsT9cPoz75dFjGdB7sWbd0mi83+3kwxyi27GfQQWeEMb
	 CAN7tXGkZ+rLaQxeLm756F8op27BBPajv5RUkHcfodj+B1Sp5ZfV7iy2zQvb5b85YaZ4y
	 7PQmVEXvUPQrVYrj9+1zm4FMksuca20ZJqfnw1OBB1cLd+0VINKiOTFIDKav34dHbHZ6D
	 kkDbrfVp0n0buqVJO5wlzQ9Qm90YkObxiw5t5vLf+r87JuW67aVir0CTY9D8Znsxn1dcL
	 ll30Ng79+yTE4WPOPyiRG6w7dj7de6fDJWe521k5L6hx6IVww4iwt3Qm9ZeP3Bi0nbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AQFi408I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1156606A335;
	Sat,  7 Nov 2026 15:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AQFi408I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC071F0089F;
	Sat,  7 Nov 2026 15:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063936;
	bh=nQvUkd0DSG8BzRzeXh4AMOPYWuo4xyEvZ9X+UF1DkNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQFi408I1/aFotMYAVCM2JCBb2jZbvbbNqETaMqnjbtwt2d7ZMjajpYXWtldZ0X7Z
	 kevSUMS1jNmRWLaQQgztzkDf56So3cse/dvTfWM1MIHTFdluMwCXYHari5eoDRXRUh
	 rDPzlZZ1UsoAsk5SHq6yEuw06XG3rDmna9YSS7Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0090/1257] firewire: core: fix source bus ID detection for AT context in big-endian systems
Date: Sat,  7 Nov 2026 08:39:46 -0500
Message-ID: <20261107134941.850486797@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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



