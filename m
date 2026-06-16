Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F49450903;
	Tue, 16 Jun 2026 15:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625547; cv=none; b=DkteqgTZ71/im77eKuQL49Dck5yjIif48wxcO+wx2zUG/sP7loMM5FKIJhoR2F9m8IPNyk6i0n+jDXXF2Tx1UZ6Bgj9Me5flVV+W4rcBM7VUPQpEgSZc7FfvBYUhgrrP54Fc1D0ccPZKa/eGWgbuSQH5Dsf41KxJcF9GVPGiLDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625547; c=relaxed/simple;
	bh=wvpMimO89iMwORtse+QX3LcYzOMg9L52kVww0GUtEe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b0lNVZuJ2B6uAV71cjOfOZHL3fckI20+S2mH5H3Awf+11VSkQhYm1KJGj49QTFwItcnIoNpVAr00lXVEbQOytM0zcVEs6NxNDqUoFILOZJ7hO0DJ4XKK8tFn9bIpcXs0Zh+Uz2FUXp6YDRe+2/R1BMQyLW7ismMEVG2+6XRJLJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0efPyTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0efPyTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C827B1F000E9;
	Tue, 16 Jun 2026 15:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625546;
	bh=raIujO796F2lcso1rugLe20uq+gOkut0i3yjdH6FsEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0efPyTYc7mppTDxSYLlNxCs5ry3tYwb6lKT3K/+aQab0qNat2f10hV7UQU1nLEhL
	 eea5N4nlB9e+v6yWxIIb1fgcJQO6fhrOMCaGbuBVoM0sdKTPjxmL7vP/xyaScV6HTM
	 tVpADpLWG4sWtJsEnapx/NHNz+FH4Eq0lm2qRfYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Doru=20Bl=C3=A2nzeanu?= <dblanzeanu@linux.microsoft.com>,
	Magnus Kulke <magnuskulke@linux.microsoft.com>,
	stable@kernel.org,
	Easwar Hariharan <easwar.hariharan@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.18 164/325] mshv: add a missing padding field
Date: Tue, 16 Jun 2026 20:29:20 +0530
Message-ID: <20260616145105.961847163@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu@kernel.org>

commit 48fcc895403cc97aa6c776cb65e6aa11290c0b44 upstream.

That was missed when importing the header.

Reported-by: Doru Blânzeanu <dblanzeanu@linux.microsoft.com>
Reported-by: Magnus Kulke <magnuskulke@linux.microsoft.com>
Fixes: e68bda71a2384 ("hyperv: Add new Hyper-V headers in include/hyperv")
Cc: stable@kernel.org
Reviewed-by: Easwar Hariharan <easwar.hariharan@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/hyperv/hvhdk.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/hyperv/hvhdk.h
+++ b/include/hyperv/hvhdk.h
@@ -72,6 +72,7 @@ struct hv_vp_register_page {
 
 		u64 registers[18];
 	};
+	u8 reserved[8];
 	/* Volatile XMM registers (HV_X64_REGISTER_CLASS_XMM) */
 	union {
 		struct {


