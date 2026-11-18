Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028079;
	b=buZtpNkI9/UurM0C5CWlyL/APBBOMFmNRgdtFrnIYkSEoAn4g04VzzQCXyct/BzuJhcf
	 CmP30+Mg00vJk8az4m16fGUuF+X8uplqddEKAlv4RJLhx7XYfzHKsOCuwPhylWdzWNn4h
	 tP0wZyUFbuLi80eRArsfhO0sxRVDLkqpyGAsSjiCtQKjtVRIE41/cTS9G867P1K6L2usI
	 F8pDWIBuLJAV+3sYKVPf9EA7ZaeLDXkk3O5rQ/XTlSxst4g0SdBcjV2cppSsY/aLSfRSN
	 PYttdUWguFN2VNjkTMa1uhPymdgGRaM5Zp+GrKbZ20Yiy/jOpY2d3FLQ1ZGPOmErjgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pBhzvqmxlPaQ/cGp74bWYscvBoE4CfKn/X8VR/6ixYE=;
	b=O/mtO1YDoWoaUPDlY/+37gvE3xrz9udnds2J2WjsSUTfK5ZZvDYFauUD3T0gAe9Op0Yt
	 61C99ci2EODVlLibm+0FB3w6qMgMhHY7+dqi5EoWJTKUXqMtIR2HnYxC/p67ivWg/Sp9N
	 iDq1AZTFmvAQ4CE6FwqVMux3FQ3gXmfgK8i8g81rxCAByDkK+a7BTACL5+zuMlMfYT9L6
	 ZCZ0roTPPlx6JjBKqUqkeLlc4SPB7xtINLa82rdC58/F23wDBOwlm0zGLzHRMgZeIm8xn
	 pS7acsUElABubLJv6QcSkH1ggY/gtnyjOD1vXwa+xO6PZLNgWtP3MF77h2dntPcdsvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=npAxgFnu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4654B606A31C;
	Wed, 18 Nov 2026 18:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=npAxgFnu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595431F000C4;
	Wed, 18 Nov 2026 18:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028078;
	bh=pBhzvqmxlPaQ/cGp74bWYscvBoE4CfKn/X8VR/6ixYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=npAxgFnur0SFuerao308jaQzJ5vgNZn4tic4RbdmAuQbM/1ueXVBgXNC9RJs6aC87
	 EKFFhpMCxnwZHT82fLwnXd720zonYDHczOHM+cFAv/hW0MiBCTEy2/E+o/KKkwE/cB
	 TpCVMtb3p23aAciYqbG0tPT1+pzG8isV/ZNR2y3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2000/2151] x86_energy_perf_policy: Cleanup: Check fseek() in VM path
Date: Wed, 18 Nov 2026 16:02:15 +0100
Message-ID: <20261118150234.577800876@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 2778dc35d40e7e84c134ca4cab1376fa58208f80 ]

Add return value validation for fseek() and ensure consistent
resource cleanup on all error paths in err_on_hypervisor().

Fixes: 0936cdfbb527 ("tools/power x86_energy_perf_policy: Input/output error in a VM")
Assisted-by: GitHub-Copilot:Claude-Sonnet-4.6
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../x86/x86_energy_perf_policy/x86_energy_perf_policy.c     | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index 4aefdd3699f40..affdaa450cc6c 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -661,7 +661,11 @@ void err_on_hypervisor(void)
 
 	flags = strstr(buffer, "flags");
 	rewind(cpuinfo);
-	fseek(cpuinfo, flags - buffer, SEEK_SET);
+	if (fseek(cpuinfo, flags - buffer, SEEK_SET) != 0) {
+		fclose(cpuinfo);
+		free(buffer);
+		err(1, "Failed to seek in /proc/cpuinfo");
+	}
 	if (!fgets(buffer, 4096, cpuinfo)) {
 		fclose(cpuinfo);
 		free(buffer);
-- 
2.53.0



