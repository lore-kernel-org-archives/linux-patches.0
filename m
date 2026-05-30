Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5962690D5;
	Sat, 30 May 2026 17:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160740; cv=none; b=Rnod/j2K33VcK4scIl6XOwKmQ+edtq1f9dSRdvEegidPmrWt4wyImPkMK9M6MIO60SLLok4TZ8TTZfeImXIhfFIcrsiHcDdNFPrLP1NefypgTvEC+PWx6iE4aeeCAnn9XtAKd7e7vtCcLCtP7VnkKjYjRMmTiJis0irB3Vd2x2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160740; c=relaxed/simple;
	bh=Mh+3IGY8eebh8MoIdsvATYBdrASEO2I54zkWM42QfzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neuX2s3j3IBO+ME8eQYH9uKT65hYqkkKwDdXl4uLhg6Otom1EGN/AiLUbM4konCcXypLnD3Ih7O7EIppDhMJN2bl+Jj/7L8Mw8McraMYO+vAk4kvkRwGQ5/g1ALEld00tz2Xd3Tf1eqJJF9Ik+ArxPuBh1Egih2ClQ9KPKjC7KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ggU0pOAE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ggU0pOAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D841F00893;
	Sat, 30 May 2026 17:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160739;
	bh=jDTsakqwyQVl/3r6+18o30vCqV3DUC/xwhtRJx8SDmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ggU0pOAEEmFt8+du6UpbniX97nkYAcHfql4NGHa8os5hk2E1I0WZqprvzLCD21gJK
	 QIXBhum6QmY8FaETg+yDBEeJ6zaaWP4rSNtBavXGCM5dorJTVZ7wJauqLlRbnLluuj
	 VozO0deeDDgpGvLs6K4C2NtG03U1KedbFdrVZQRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 404/969] drm/amdgpu/vce: Prevent partial address patches
Date: Sat, 30 May 2026 17:58:48 +0200
Message-ID: <20260530160311.442942067@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Cheng <benjamin.cheng@amd.com>

commit de2a02cc28d6d5d37db07d00a9a684c754a5fd74 upstream.

In the case that only one of lo/hi is valid, the patching could result
in a bad address written to in FW.

Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
@@ -658,6 +658,9 @@ static int amdgpu_vce_cs_reloc(struct am
 	uint64_t addr;
 	int r;
 
+	if (lo >= ib->length_dw || hi >= ib->length_dw)
+		return -EINVAL;
+
 	if (index == 0xffffffff)
 		index = 0;
 


