Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED05523BCF0;
	Mon,  2 Jun 2025 15:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876493; cv=none; b=a16hM/t2S4K6LiFKg8fe2mHtzYkDtp2VREdKtjzrKNXr5/kiVmjtmnus5ILQKt+A+YN18KosLbHtHwYiZ6zVniSqVAqh95183TCeFxDWtJLd2nPRhWzTqqerDB717zjln2zYRjRrSH7LgB+Wv6YJlvUvx3kn8HO/VcpNCKg0/JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876493; c=relaxed/simple;
	bh=zeGUr/OmRqfJzmCtW0NWriX2mjcM9PyPcGK8GHp35A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmT2T4OwJYsT29OnvsbvH7EnMX/6KfSy1SVfP4EgElyNaVXQRzCXap5/TGit/L2oS60xcnBdTr/nuXsJU7bwkI4zHQqgPRg4YfrDVe9OkvT+xtOCyQvJEuxECaVawxtSHJQfU+HK83Isx8mrm0zU/QMqGytqE1ywNesUaMShODs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0VN1ot7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0VN1ot7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0385CC4CEF0;
	Mon,  2 Jun 2025 15:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876492;
	bh=zeGUr/OmRqfJzmCtW0NWriX2mjcM9PyPcGK8GHp35A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0VN1ot71yvf2DhPq/SjqqV9zcuFU0IyVxOuu9XkJgglwKL4ZAi+JJyNZyGe+prIo
	 MugvlaPNt+HflE0veeDlyuueGMktkjiQjOM5Sw9GOG2cvBdCgVSyyN5ljYB1cZCrze
	 Iniy4wpN7elYLeK4SYuC/iKLGQjiQNMMGJ8N3IVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 192/207] arm64: dts: qcom: sm8350: Fix typo in pil_camera_mem node
Date: Mon,  2 Jun 2025 15:49:24 +0200
Message-ID: <20250602134306.296585122@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -240,7 +240,7 @@
 			no-map;
 		};
 
-		pil_camera_mem: mmeory@85200000 {
+		pil_camera_mem: memory@85200000 {
 			reg = <0x0 0x85200000 0x0 0x500000>;
 			no-map;
 		};


