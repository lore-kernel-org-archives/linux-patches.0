Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9621C93C8;
	Tue, 27 Aug 2024 15:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772614; cv=none; b=qPkicX17G8ACo/b/XIGHtwFjUk+f/lcwRIyuY+VuWHobkJjQCbeu96iU2YZvXBkiNsk4WYNlSW2RtVwxTwDaK6xt8SoYHT50xH906wihOk4xFQpK6rp8Y4iPldDUDsPGR0R1fX2o3/GOsi4enKsIbuMV/NbfmJAENqDmD6GcgV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772614; c=relaxed/simple;
	bh=aI+GoCYHkMcYRBjoMOxjpTgbRCCaJN+fJNBh6m+MQdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dr0YVM+zjjPu9SUEr4FKlfbi5yED+qRa8hB8+Miw27yayJxnHMU5W2eifFa69aBu+7ur6LE1Y0QmJUZS/lmHly4PFWzUqcfJlr1VzD6UJyvddnYnZJ1gh/JBa3sEplJ633YS81KUnF2pNm5Wz/i2+pyekBj+gNBhB5/y9YIqF2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APoNNDKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APoNNDKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68114C4AF65;
	Tue, 27 Aug 2024 15:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772613;
	bh=aI+GoCYHkMcYRBjoMOxjpTgbRCCaJN+fJNBh6m+MQdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APoNNDKALR2Bgo2qRLvHYDHrtubC+aYJVQyDDQlcDbkU90SoEPZp994NT19ZNM1MX
	 u/7zeVtll3uOp28+f9mweML9nGgqs0/VPvNmyb5XubS1JjDj/jM41ipIjXrCJ3ekhb
	 +l5d0Ok9OruX6auq7UiK/J60EIhso7/uBY8Ot/vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 266/321] drm/amdgpu: Validate TA binary size
Date: Tue, 27 Aug 2024 16:39:34 +0200
Message-ID: <20240827143848.378115873@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Candice Li <candice.li@amd.com>

commit c99769bceab4ecb6a067b9af11f9db281eea3e2a upstream.

Add TA binary size validation to avoid OOB write.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c0a04e3570d72aaf090962156ad085e37c62e442)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
@@ -148,6 +148,9 @@ static ssize_t ta_if_load_debugfs_write(
 	if (ret)
 		return -EINVAL;
 
+	if (ta_bin_len > PSP_1_MEG)
+		return -EINVAL;
+
 	copy_pos += sizeof(uint32_t);
 
 	ta_bin = kzalloc(ta_bin_len, GFP_KERNEL);


