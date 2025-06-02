Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F05C2C327B;
	Mon,  2 Jun 2025 14:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872889; cv=none; b=eNfgCy/MxzeACT3x4u7vyreQBbqxBq9l1WToORISlx1mxCwVPG3rCKNvyGSMxPUEVF8FsCNNCZx+fscdAJABR9LkSDTBLiOoraM6OWM17Jg2YIjErQdtR0mE/+YbSy+4Q6KEURLx4eK8LjJoj2p/S/8+B2UfNzZPvi4dAddBarE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872889; c=relaxed/simple;
	bh=gBteSSYCzoB+nARsQqe0kjskAPq55I2IfuQO+2VKqPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTe4RJ5uGyDfohdKuor0Yylm+EJgxS2RiHB2DklZ54BMo4JcNitmtmNFw8P6yN+xyZla9D48UrQpg8hu9jG+D503jEAv/EvfUaFFzsChzzR1tDrPkfoRn6ZeG9i5Q8MQEK+d/xHlmGLoQBQITqsp762mpcqDPdpVJeUKB0wZKaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rloahgxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rloahgxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62507C4CEEB;
	Mon,  2 Jun 2025 14:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872889;
	bh=gBteSSYCzoB+nARsQqe0kjskAPq55I2IfuQO+2VKqPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rloahgxhI8XWKAl+P6vzjXGwDFZ0PvoabVRGhvla1inwIRBRZQOMoGhQQOfPypsJF
	 z+UuB4MpmeQotlPmBI+2YdoeP47dK3zurZ79+N+ROzt1J5bKXDnwyzCu+eCbH4OYa+
	 7/ND202mN/vYGtDtrvOfko8KNHDu6RaqaSRokw1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 05/55] arm64: dts: qcom: sm8350: Fix typo in pil_camera_mem node
Date: Mon,  2 Jun 2025 15:47:22 +0200
Message-ID: <20250602134238.481858849@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

commit 295217420a44403a33c30f99d8337fe7b07eb02b upstream.

There is a typo in sm8350.dts where the node label
mmeory@85200000 should be memory@85200000.
This patch corrects the typo for clarity and consistency.

Fixes: b7e8f433a673 ("arm64: dts: qcom: Add basic devicetree support for SM8350 SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://lore.kernel.org/r/20250514114656.2307828-1-alok.a.tiwari@oracle.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -455,7 +455,7 @@
 			no-map;
 		};
 
-		pil_camera_mem: mmeory@85200000 {
+		pil_camera_mem: memory@85200000 {
 			reg = <0x0 0x85200000 0x0 0x500000>;
 			no-map;
 		};


