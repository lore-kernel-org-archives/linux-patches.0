Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046080;
	b=fahPXfmEXvOvU2PXDgq0868/ZZFf2Uo6X0P1dl/a+16nM4K8FymvbRkiH7KpV8mznFgW
	 NWYEKYxKvCUG3XML/tuJXAMp5bHhjbpfPXXwc1pYZNnW/EigDDa0bvEuX3A4FtgqMel+i
	 jM+cFyfpXoWJOowxTFCDx7XKYFVBSYntwcq4CkAqkT/RnAzo1fC4c7jChF8WhrHTk/66Q
	 po9z3wlfizYcjStAqWB7tYhdnRrC8IbKf4r3V3QTSd1lU5+8zkGLMi8sZiGl5VtArKnPM
	 NnEqqHGsQhhqOpS0TBlw0MBXfiLqQBcPgKC+kXUWhNnmn9Bm1hGieIF/Yy0Sm+n+Pbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eiMcgf1bnMCB3E3+SV4cRmq/qtq/VRBBhwAIKJtBPHI=;
	b=ZryO0QhQvIK8KTLuVY/oj3BtAv+altvBWYuzP5V/4hCPLVHm+CtdgISkok8dVyImoO9D
	 xC47tRGkhxisX+FxQkt7b514nVDM88cvit13fBRgfTZ+EtLtA9Qcv/aedhsUxVGb+Y+Uj
	 KKNUWwnrxiHJpelAyOKXZ/xCMR9tjiK/LUqYgZMke4efg0vRxkRgbxRmNbpCHoMJx04tJ
	 h21eIHLgAmJOu8bB0vI1V6SqnfkCkDved9P1M24/GUI3N/hNgiKkO1Lb35SgliMTdkwVF
	 eFCnMZHc0JzQYaIh+aWiDeulw0q57fCdv++8kVbJ5Pzs8np5pLhmfc6Y9xwSJVoILbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xfVBDapZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E4E606A32A;
	Wed, 18 Nov 2026 23:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xfVBDapZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42ED1F000C4;
	Wed, 18 Nov 2026 23:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046080;
	bh=eiMcgf1bnMCB3E3+SV4cRmq/qtq/VRBBhwAIKJtBPHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xfVBDapZcLM1hc98exITUVYrW2qJeGg2NAjelMtxvaZQcq0OIlQ3kvYlzMDtTf6hz
	 M9/qd7mJM2lwnKwtbsqC0G4ejI3JO2cJWBvYVmdI833p8e4gTMd7GovBt44+/y4ZG/
	 b8AZfc8iSfbHopvpApqDF1WXHMff6cqpTIUbWRzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1152/2857] ACPI: CPPC: Propagate errors from cross-CPU FFH calls
Date: Wed, 18 Nov 2026 15:36:26 +0100
Message-ID: <20261118150243.062579050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

commit 36e96b469da24868f727b4cd168d7cf01cbd163d upstream.

The arm64 and RISC-V CPPC FFH accessors ignore the return value of
smp_call_function_single(). If the target CPU is offline, the call can
return -ENXIO without running the callback. The accessors then consume
callback output which was never initialized and may report success.

CPU offlining leaves the CPU's CPPC sysfs attributes present. On arm64,
the AMU feature mask does not exclude an offline CPU, so a paired counter
read can expose uninitialized stack values through feedback_ctrs. RISC-V
has the same problem in both SBI and CSR reads, and its write paths also
inspect an uninitialized callback status after a failed cross-CPU call.

Return the SMP call error before using callback output. The arm64 single
and paired counter readers already check the helper's return value. For
RISC-V, also check the callback status before copying a read value: an
unsupported CSR sets the error but does not initialize the value.

Fixes: 68c5debcc06d ("arm64: implement CPPC FFH support using AMUs")
Fixes: 30f3ffbee86b ("ACPI: RISC-V: Add CPPC driver")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20260916162805.1039247-18-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/topology.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index 7f50162ee7c83..e712f315af452 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -291,9 +291,7 @@ int counters_read_on_cpu(int cpu, smp_call_func_t func, u64 *val)
 	if (WARN_ON_ONCE(irqs_disabled()))
 		return -EPERM;
 
-	smp_call_function_single(cpu, func, val, 1);
-
-	return 0;
+	return smp_call_function_single(cpu, func, val, 1);
 }
 
 /*
-- 
2.53.0



