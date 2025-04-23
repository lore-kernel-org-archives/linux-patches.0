Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B770628A1FD;
	Wed, 23 Apr 2025 15:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420965; cv=none; b=dDlXKItCkpWYlPWs5ImqzsTJls9p+Zovpcc9djsqm8c8LY8VBEiIU/B6EUpE37pckYm4n8I6XUvOBwfVmw8uPtsdXr95DMV0MczVyncwL7Q7AJwx4lHpYxMwcSyfPE4rHzEqvVBrih48OPkG2daWEU6Fh44vbVKE4Zsw5xg1FSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420965; c=relaxed/simple;
	bh=nGVEYVF7LM4RV8w8gbdsGBtXCV2FUsKlFrrwgCYPoSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PW+905k7oAUO87RAPkNAhUQ61C7kR83gWnDo+VZebMzi34sc3FnDFwqVj0IaOpXlyL+bD4+Xs7wxG5kvQR9KhYZo1umnuQmjxw4k7Tx118jwqiDP61j3l2NbmdPBNY1YIKxYCiYdm+jIfTf2LzfWSXjoSfIpCQSBxtr2bfRTqS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZ4lPUED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZ4lPUED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F739C4CEE2;
	Wed, 23 Apr 2025 15:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420965;
	bh=nGVEYVF7LM4RV8w8gbdsGBtXCV2FUsKlFrrwgCYPoSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZ4lPUEDLw6yo6nHyJkDRAmvtl/8CkDtqo1zB+l8e4KBjy9qNhWsvB0eQN9t+kVMc
	 D59QQysEDe2YRmmu9KkmitqfjA5pgRXdmXHu1c0K+QylmPV/ukGZC0xqIphC7U4vkc
	 dVbQ5VRWaAJG0OZ1EfdiRmiaDHzdiqw2wvp5/6u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Bauer <sbauer@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 131/393] arm64: errata: Add KRYO 2XX/3XX/4XX silver cores to Spectre BHB safe list
Date: Wed, 23 Apr 2025 16:40:27 +0200
Message-ID: <20250423142648.768588587@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

commit 0c9fc6e652cd5aed48c5f700c32b7642bea7f453 upstream.

Qualcomm has confirmed that, much like Cortex A53 and A55, KRYO
2XX/3XX/4XX silver cores are unaffected by Spectre BHB. Add them to
the safe list.

Fixes: 558c303c9734 ("arm64: Mitigate spectre style branch history side channels")
Cc: stable@vger.kernel.org
Cc: Scott Bauer <sbauer@quicinc.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Trilok Soni <quic_tsoni@quicinc.com>
Link: https://lore.kernel.org/r/20250107120555.v4.3.Iab8dbfb5c9b1e143e7a29f410bce5f9525a0ba32@changeid
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/proton-pack.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -854,6 +854,9 @@ static bool is_spectre_bhb_safe(int scop
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A510),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A520),
 		MIDR_ALL_VERSIONS(MIDR_BRAHMA_B53),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_2XX_SILVER),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_3XX_SILVER),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_SILVER),
 		{},
 	};
 	static bool all_safe = true;


