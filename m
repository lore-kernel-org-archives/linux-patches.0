Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938DF36F8F1;
	Tue, 16 Jun 2026 15:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623670; cv=none; b=BRBuWR8syLRYQ1CuEBgbHNtifZYV3p0ZPPv+jEuTtlZHUxzHryM4h+mv6QHOhmORkY5j/ZiFSI2YTX7HvjDVoJIl22sc5GuIq112/PjQZfhoA3TTeVsK8fjMCt3RLiMROpSihwB1dg42S6hLDmEBreb/ZAn00x2aGYGlp+LpIZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623670; c=relaxed/simple;
	bh=/ynmUyEzMVMV9Ge6+qieCdU+mAKsyJe/av6EEcxJ/AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e+AOb20gzva7DJcpoSEvMrBTY+thtZubKUwmS6T+Z2xAfu8Ax+qAhMNsjqz/+1hqVwcF/CCyDxRmWAU9KMM7+6sjgHwaxqDRPYOScw5zsC57tgJ4szeWmssfxpGpjwe7vFc/kpyMxWGHbLgXg5KrkSUaiZqK++v1Y+NTVhLcxhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2I66DQE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2I66DQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9289A1F000E9;
	Tue, 16 Jun 2026 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623669;
	bh=cX7EtNWu6lT3AD5M+6HfPMES6/Z1WH8JbSpewuZGTEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2I66DQE8m37QL76qcJYlmTcPxRC31U+ki7SXjchFSYyuFRC6LprW01tlWdvNUzNo
	 liWPIYXwZan9yrk5SR9BgwUeh7tP5E71clmtAttzx76oFJSVMQcRbpfFwSoqIu+gpt
	 TE6cLcBEcZBCv6VI8zB/FU5ahE7UnXVoRvd/ybYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Doru=20Bl=C3=A2nzeanu?= <dblanzeanu@linux.microsoft.com>,
	Magnus Kulke <magnuskulke@linux.microsoft.com>,
	stable@kernel.org,
	Easwar Hariharan <easwar.hariharan@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 7.0 194/378] mshv: add a missing padding field
Date: Tue, 16 Jun 2026 20:27:05 +0530
Message-ID: <20260616145120.600529591@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -79,6 +79,7 @@ struct hv_vp_register_page {
 
 		u64 registers[18];
 	};
+	u8 reserved[8];
 	/* Volatile XMM registers (HV_X64_REGISTER_CLASS_XMM) */
 	union {
 		struct {


