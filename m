Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018062;
	b=Iu46xOTx9pCbB8th5fsdWHg5absMzU4iF0dQ59OS/3CUomrdM02Jtq21cwwY1xhRoGWU
	 Jn4lekj1q6YzmFR3fKSUkODhEM7UFcVpIx6r9HI014nKkaksRsOFleXGRU48nmQrDphIE
	 FL4/ZoYWWwOGQwPdh/f2TZgYfuRPA+Rh1tp7EOgBvfk7g1fWoVLNYOmKzDiIhZ+AT9R8W
	 gzT85hUvVjIhqxNLiLNPSQdGjcUaW9CNCEdCrjnY8A8NsTP60dxZKYLqKG8m12L8qeZF/
	 9I19lJsu1vhWIAy8TMIaLXokLhowLoH9EJV0ZW2/NSvHjJtU60f0Wf3n5MrXzF+BNGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3B/u/N42xytnI6oynFvY9/pgVYs7sYSnAxFHsYg4/JI=;
	b=hnlhIAVueXxDstcpHWSbfW+jrleYIYPcMqi8Hj5V4o1eJ8PeqssrZxtntHfNwMfYtLzm
	 149dTFOV3JcLEE8Gt60a0O5GmXW8rleI8ubnLghQarYgcaLW6luuvuMO1Be8lfrubQLYs
	 5LRKxvqd8v3TPkL3PomUtfcMptdOhkLMyqC+RG6xIywdQio/EiwtmprbdZ8JUaB7d3obf
	 fntxNBRDeiemRRvVJask6UUpcCAFGk1lL7SwkEeMCLbPxAxpb2i76pSFS//d/HrQH7UHc
	 ZYhpFQOMecdGVKD72IqBxhTxGScil2aj9Mk2Iwv4qU5w0F/eTOzV7QtIvJMsXvFN4dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0SAazD6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1C660A2611;
	Wed, 18 Nov 2026 16:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0SAazD6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7891F000C8;
	Wed, 18 Nov 2026 16:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018061;
	bh=3B/u/N42xytnI6oynFvY9/pgVYs7sYSnAxFHsYg4/JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0SAazD62TAYfMXt7EYbnSTLG+Jjh7mzkXwLHEz8QA0OO1qAopjb88x+A5/2cAIBn
	 wXY4qf1egpK8olqB+dAsu6vwaVwfSm4jjZh/yGye4I9JL+vOj7EAppC8P7kjR6355L
	 4xctZ3OAbVZtm8Rslw+KDwsIeRmEkq1LZKLo0Oe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Nowicki <mateusz.nowicki@posteo.net>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1106/2651] arm64: dts: st: fix sai3b unit address on stm32mp251
Date: Wed, 18 Nov 2026 15:39:06 +0100
Message-ID: <20261118150327.810530105@linuxfoundation.org>
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

From: Mateusz Nowicki <mateusz.nowicki@posteo.net>

[ Upstream commit 64a74189380955bd2d45e5e38a90947b0f63efd3 ]

The unit address of the sai3b node, 502b0024, is the address of the
SAI_BCR1 register in the secure alias of SAI3. The reg property of the
node translates to the non-secure address 0x402b0024, which all other
SAI nodes use. Fix the unit address to match.

Fixes: bf26d75a95f1 ("arm64: dts: st: add sai support on stm32mp251")
Signed-off-by: Mateusz Nowicki <mateusz.nowicki@posteo.net>
Link: https://lore.kernel.org/r/20260924193759.27881-2-mateusz.nowicki@posteo.net
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/st/stm32mp251.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/st/stm32mp251.dtsi b/arch/arm64/boot/dts/st/stm32mp251.dtsi
index 2dcbba65e2986..f81fd06f4be5e 100644
--- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
@@ -1291,7 +1291,7 @@ sai3a: audio-controller@402b0004 {
 					status = "disabled";
 				};
 
-				sai3b: audio-controller@502b0024 {
+				sai3b: audio-controller@402b0024 {
 					compatible = "st,stm32-sai-sub-b";
 					reg = <0x24 0x20>;
 					#sound-dai-cells = <0>;
-- 
2.53.0



