Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905401C5788;
	Tue, 27 Aug 2024 15:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771564; cv=none; b=e97bUKnZxOOnqqEi6CHywbtJ7xlbwPjJaRjJC7SbgJIEW/oG9Px9lV/z/RyBrtzOSD+sGXHR3KpnmlgsWNetKxAngkBIk6hCvFXNRirqp1NqbzxMJOXFTPHPB5nnaAfnkDr84r70nVZCfQ+YWVFrtNxTn5C5ZzOKks3EQHYt2+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771564; c=relaxed/simple;
	bh=lAui+eT/eN+vZXZMQqxJ2vtI4eXsgzHVXrSCT8fqNmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BudnvUcZRiGtnBuzsEDBfR7e79Vca6tefpOojmfy5/q+HRQ2qFYujpqRl7ymgwDSmP0TqVt3KMEQjf7B8yk1L7O++ZqN9ijXKkNPC0kjoLZ+bOR/J7kD6YpZK0W05Dg93rcv5lZgt9gV4oa/S5CYN5AaFhDz0QXk8QoNb5vLPyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCQn8Kz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCQn8Kz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED912C61043;
	Tue, 27 Aug 2024 15:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771564;
	bh=lAui+eT/eN+vZXZMQqxJ2vtI4eXsgzHVXrSCT8fqNmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCQn8Kz49/LIP2CxDFuUKZ/vHdHCPwbeBbu6VhTEuuV4YPSNoVi8PNSdB5/ug3dAA
	 LW28MnOPT1ZgBUac+GhUDGRM2xmpySACATpOhfsZHdGaYAeFETyH2vR8jNbjJCozbh
	 lCq3qW4bSvvZNe5rP+XphhPUmaoTmTdsYCZEgh8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 226/273] drm/amdgpu: Validate TA binary size
Date: Tue, 27 Aug 2024 16:39:10 +0200
Message-ID: <20240827143842.007822809@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -166,6 +166,9 @@ static ssize_t ta_if_load_debugfs_write(
 	if (ret)
 		return -EFAULT;
 
+	if (ta_bin_len > PSP_1_MEG)
+		return -EINVAL;
+
 	copy_pos += sizeof(uint32_t);
 
 	ta_bin = kzalloc(ta_bin_len, GFP_KERNEL);


