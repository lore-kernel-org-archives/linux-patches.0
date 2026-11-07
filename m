Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061442;
	b=V33ZzKvody1vbq3460Mz8KfsGoUltczAlQZE3KokkZpTwuy/ujyOHNYhKl7lUcttzQqV
	 KUKIFl5TvxpCnL+UO0OycC2DCFJlfR7oomuXrt4IOJ598jYhmNCPLc1lddByxhWfWq4cv
	 8ZxNtWNIL5jtrlLCRW7ifNm+jKVRFirtJb8h61O1RP9nC45cmZ6z5hNycukV7JKrnIPHW
	 rJKGdElhSRPI9o6b+UviDqUgQAwA5eexQJ7QetqMsNuC+6qwsghMQQf3wq2A/6fLnUuFm
	 xCIg/BRAtBlyzOXYLDGX03JG5VV1sJwEZ27G3dJJDfcqwUWUS8mzNUnYtOX8bfAoKhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ukc9XKMG9kUP3hOSuhevHqc3PYUeTAO4pCFgwGcNkC4=;
	b=Xn16qraLFhAbe7WhLXJWPw1K3+kafHc7Yu1/HWOZBlbxX50SKdaQtBFhEEgN1g5j2X57
	 HJZ/4hfKTlee8h1BSKCIyRvNztQam7w3N8U7Id141c7hLumTlIac2hh3w6IC1J0QT4kw+
	 gXi/WkeX89FYL2vhkMIPcpp8s+h9WFufkVNR2DhCdWB2yT5kX7LCthBxWWyKH17peEmiQ
	 lAkGUjPre77m6TelMt3TWKevpsCNUXRgmi1xx7i4p1Cb6yEIJjI+g39ZqDRJRhNBqBIg3
	 iQDRnoZMI1c7OTRggmI715dVkoQRk8rcZpnKZE+5hoHlHCr1ciogzjkPsFoBGUqMojQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b6YmgHjx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C032606A326;
	Sat,  7 Nov 2026 14:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b6YmgHjx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C611F0089F;
	Sat,  7 Nov 2026 14:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061442;
	bh=ukc9XKMG9kUP3hOSuhevHqc3PYUeTAO4pCFgwGcNkC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b6YmgHjxQQf2nPMCY7PgoKVHaBmeLmU+TOsPAcjVh2d1UhmrE1nSx+qfvGDgVMXsi
	 pqKdg9yngpjqD6o/+QCFWOb/lqNAMxg9s4G4Yjp7kdBs4/NdwF5f45vsZAuBejFuqe
	 Y3Aaa9m80lmsJ9noQQtB8nW9UUjK2lndvj1o2pqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0550/1536] drm/amdgpu/gmc12: properly pass flush_type to gmc_v12_0_flush_vm_hub()
Date: Sat,  7 Nov 2026 08:42:46 -0500
Message-ID: <20261107135013.050788851@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 0bfb1bfc82e8fa386d4fad1caa5812b6afafa626 ]

In gmc_v12_0_flush_gpu_tlb(), flush_type was not properly
passed to gmc_v12_0_flush_vm_hub().  This only affected
the MMIO path.  In most cases the flush would go through
MES.

Reviewed-by: Mukul Joshi <mukul.joshi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6498e33f22a12fdc759a0c78bfe0547819277a36)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
index 7e70d6f8726af..91da98682b9c7 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
@@ -339,7 +339,7 @@ static void gmc_v12_0_flush_gpu_tlb(struct amdgpu_device *adev, uint32_t vmid,
 		return;
 	}
 
-	gmc_v12_0_flush_vm_hub(adev, vmid, vmhub, 0);
+	gmc_v12_0_flush_vm_hub(adev, vmid, vmhub, flush_type);
 	return;
 }
 
-- 
2.53.0



