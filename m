Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A563D8912;
	Fri,  9 Oct 2026 14:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556454; cv=none; b=SNFKoz0jCpK6vpAyPm5Ekunfypd7lSj6Sq5VLEQ7Kedkjmr/17elYSv7JDmBYhFfWFwRI3B0nmYaUQM3cMN3Ceq8LPQWNnU/dC+D/ejj0bj7v5WHn6a1J3ETOE+rPneOcqJj+Yfqaq0NHKOn+pfPvaLrKjKBabrMjIQW33r6Z8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556454; c=relaxed/simple;
	bh=F/cZ/ZAL1ZGoHwDZFyu+dZAeHFN4v9JtW2v0iRodIZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Go2+VPGQTw1+Y7JgiM27I4ub5H5Xl5wu+9GO9U3szAOj0MxnTeatVJx07T2xzAlBeMRV3BQc9YtNQ+NDoyBtPIWzxOFhjblzTy+eaViZR7kt0Pgs5NeE2rTn7HkODSfB5STZXLn5gyo3msWuAzB6XK9TjrdKEp1/ijflWs0ekeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCZwKzZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCZwKzZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A4C1F000FF;
	Fri,  9 Oct 2026 14:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556450;
	bh=suzkcWQOtIDrW2Ew4csWamtvvw37OdAkkj+/+lsX3lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCZwKzZhrlUgdjR2tJiOLqZTx4SxAwWW7/qqpAWWPzfX4XZjyPqQysY7xqwKgobSW
	 /3+MQFF1WPfiTuuQR7B/tKBxHSZ9V2PJHINuVNk1MLXh7dbcPyZDkfrqLdgpEzoztB
	 K3pv8lzvBjMdvvnrFR1OPGjACq8zOTJeX+4ptQbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 178/428] drm/amdgpu/gmc12.1: properly pass flush_type to gmc_v12_1_flush_vm_hub()
Date: Fri,  9 Oct 2026 16:08:35 +0200
Message-ID: <20261009140950.058542094@linuxfoundation.org>
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

commit e3e7fdece7069d09ddd818564853174865d4796a upstream.

In gmc_v12_1_flush_gpu_tlb(), flush_type was not properly
passed to gmc_v12_1_flush_vm_hub().  This only affected
the MMIO path.  In most cases the flush would go through
MES.

Reviewed-by: Mukul Joshi <mukul.joshi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1f0f66fab18dfa8f14db82b8a6b82dcc21926248)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v12_1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v12_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v12_1.c
@@ -389,7 +389,7 @@ static void gmc_v12_1_flush_gpu_tlb(stru
 		return;
 	}
 
-	gmc_v12_1_flush_vm_hub(adev, vmid, vmhub, 0);
+	gmc_v12_1_flush_vm_hub(adev, vmid, vmhub, flush_type);
 	return;
 }
 


