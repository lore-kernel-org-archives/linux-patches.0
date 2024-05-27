Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39019168C4;
	Mon, 27 May 2024 19:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837735; cv=none; b=vAWAXztuJIX+cmp12vE75kk21hcy72S0/cWd9JffX1YCQHlt3HSg5ldcRiUc7bqrJavxM+VxSrpNoZ4qdyaIFY0l+6eQ22CzNh/JjHHSfamfBx7DaWbyWPVCLra2q6hh8SmkMtXZacxIrNmW56rIG5Eg/HIen0+y8hKWn6WQ3iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837735; c=relaxed/simple;
	bh=9GP5cl/4oswg0LzhSMgvRdjiRgFevCg7yshFWG6fgdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kN023HBYVYNn5QrhZi2SZwJWZk1TeLZSdjvCyxV+mDTju8c8I/sfkJiyarCnQ9vGWuuThsCWlGCzT0F6M/jm9Blryna/Eyc9G4sgg0QDM2QOCJAjmcIPcUpLtIuskwTvtn4AQRmVfnkALBgzNHb2YA5Ojfz6KimconPSfOM0oLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7jMCALJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7jMCALJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC0BC2BBFC;
	Mon, 27 May 2024 19:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837735;
	bh=9GP5cl/4oswg0LzhSMgvRdjiRgFevCg7yshFWG6fgdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7jMCALJ/aQFkNEXvX3i0AAwPNCdMvSwHjfYMV+sELq3gkAQQgVIyODflDxl3OgJX
	 Ez42nCr5YqOWvLxhYWbc/jjTY2uocNCD/3jQtU7oDXIRCAmej8uVH+spzlZU2EmPRK
	 o1/qzzczpsjS6Wd2Ggo3GQT64+FYxELE/eq3v/dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 087/493] platform/x86: ISST: Add Grand Ridge to HPM CPU list
Date: Mon, 27 May 2024 20:51:29 +0200
Message-ID: <20240527185633.194981238@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 515a3c3a5489a890c7c3c1df3855eb4868a27598 ]

Add Grand Ridge (ATOM_CRESTMONT) to hpm_cpu_ids, so that MSR 0x54 can be
used.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20240422212222.3881606-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_if_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index 30951f7131cd9..1accdaaf282c5 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -721,6 +721,7 @@ static struct miscdevice isst_if_char_driver = {
 static const struct x86_cpu_id hpm_cpu_ids[] = {
 	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_D,	NULL),
 	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_X,	NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT,	NULL),
 	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT_X,	NULL),
 	{}
 };
-- 
2.43.0



