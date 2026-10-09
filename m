Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F6C125AA;
	Fri,  9 Oct 2026 14:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556458; cv=none; b=FBhBtYteBQR2ZI+9F5BhLqNLNiJ39P1HLOc0lm1XdRIJ3lqGF2zyDhE1qJ+P9oXqqx7PG4yu8g2GFktJt2qmSsODCw33XkxYxaX3wPHE1IDsXs4RfPnPoTL9XUAVQJmjnLH9zgXwNLsQmjd3VXJagdRERvZMwuTSoo5Q1lH9eTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556458; c=relaxed/simple;
	bh=qM2MrFgllUcqBxSW3AUC6K98sNbDmfgXXgI4tqV7RAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVb5Zqig7iBiGAUAghofJ5yK7DR41HcM7SbudSJxE88cSNEbNDFVdYP3MuOPNej6g7zcTOaiUcOLAiRYqnDpve1nk5wVlKIRpV4/Z4h1sixG+4Ktk2e+5t27xu3GogT+tmrNDQBui0vf87NKtBMfqJMqUHW9m3VgkRuHu9MQl40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaXLanXC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaXLanXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1241B1F000FF;
	Fri,  9 Oct 2026 14:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556456;
	bh=wwv3WMKuV+fMq51J2/n2BXvDS1uo22RLMUCzvCmWk4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EaXLanXCVp0cPrXAW2xeyOIQTkuTOikqNr3RLBmtBRkofKmB6Cna8i3o/yWGcdaTV
	 iLgVoAFpipL8YkkFTluOngKNfdrGsoQ9JETPZh7O/Xp2eq5Bcj7hL+tjEsqJ182SKu
	 8QZdchNP2aOma0WqpNMcxhzPWwcbd9JwkzRv9bPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 179/428] drm/amdgpu/gmc12: properly pass flush_type to gmc_v12_0_flush_vm_hub()
Date: Fri,  9 Oct 2026 16:08:36 +0200
Message-ID: <20261009140950.078656352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0bfb1bfc82e8fa386d4fad1caa5812b6afafa626 upstream.

In gmc_v12_0_flush_gpu_tlb(), flush_type was not properly
passed to gmc_v12_0_flush_vm_hub().  This only affected
the MMIO path.  In most cases the flush would go through
MES.

Reviewed-by: Mukul Joshi <mukul.joshi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6498e33f22a12fdc759a0c78bfe0547819277a36)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
@@ -327,7 +327,7 @@ static void gmc_v12_0_flush_gpu_tlb(stru
 		return;
 	}
 
-	gmc_v12_0_flush_vm_hub(adev, vmid, vmhub, 0);
+	gmc_v12_0_flush_vm_hub(adev, vmid, vmhub, flush_type);
 	return;
 }
 


