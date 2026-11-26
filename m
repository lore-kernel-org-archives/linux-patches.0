Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704949;
	b=spLBXw8hXZkAeakp9qvbolf0dMQ2cw4MZ3QMvOErK5dZdZrLEjyRJgZRAbnra97tXXXr
	 OomC0qNy/Jd7Rwg8+YHYz30SFyiSRwsq3KY4vzmFqxjP42pqxvF9J73UgAILL2nRcJ1EX
	 NylJt9WjrNJbrd3J+NxyLuUzhmbPLmjB9ZUaKQsib4jEdQVz+hx7ieueUV98vsav+q151
	 F0djDN46kYmC+ScykKMJPSctT+OhYXNjrAsQvxQjZmQ/qXDbmlFEw8OliO6Q2WwVDg2g9
	 +8vtMtW8KcwdkQVYkj5PHf4EY6CPGU4TqILe5l3mgSgqS9iKDdOMt5ikEhVA9Yc8lDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tDzS4JmVJd8lIefQtrWC/x4K0FIf2wMOAXtTNXzIK4U=;
	b=EexXIC5ELwNu+FKb9hQbQViNBco7Id5dR9m9AN6DYno220Fe9iqqZwxosHSrvIlM+eQy
	 8ID88nYJnfX9RmQUxRnE0z0oZ3RQ+8j5stgD2YvjyfOMMY5C6XGRU/uzJTiw8zXLaqm/7
	 MCzPdW/aGClBK6JEfvbgnvVEjXkb19IvWmApNVvdtNvf4psjhoEwnoAZJxNN+YLgBNwWt
	 BQ1h72M9s+cS6ubZGGwfTDo4Ep64BQe8Hg8je8L51eZKmuCEfKvOSpTC6S+6iYhGvYw1f
	 HJzK2vexn7BLZhFnli1sh+LpG128/vCNw3SvnzuYHiyGPJ7AJahJdF7M60duGQ9ZXZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NlPMB1hE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8C7606A682;
	Thu, 26 Nov 2026 14:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NlPMB1hE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613EF1F000E0;
	Thu, 26 Nov 2026 14:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704948;
	bh=tDzS4JmVJd8lIefQtrWC/x4K0FIf2wMOAXtTNXzIK4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NlPMB1hEhDIo/+kwGAFYMPnDWGEK/kiqAL1oHaahpHMlJnTR2jGIQ72hnUZidmRYj
	 3AWKMGQ5HvbsZHPgmfxp71gik+9HHsUV5uhSYs7HIJFnlKUM9BlWg0MVay3A662S1F
	 f4cMD0NC4q6YcEBVcnTZLxWrRGT1fiVmLZkRAl2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/319] drm/amdgpu: Check cs flags.
Date: Thu, 26 Nov 2026 15:36:16 +0100
Message-ID: <20261126144006.928427214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

[ Upstream commit f5ea64f9fcd921bc4e2307a262e19450b8a58524 ]

Had no validation before. libdrm_amdgpu memsets this, even
for the raw/raw2 functions.

We have a lot of functions touching the ioctl struct, no
strong opinion on where this is placed, but I thought
early would be good.

Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reviewed-by: Faith Ekstrand <faith.ekstrand@collabora.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d01e15e76358f60ef6734462d2b6d9972b9dfbc)
Cc: stable@vger.kernel.org
[ sashal: Moved the flags check from amdgpu_cs_pass1() to amdgpu_cs_parser_init() to match the older parser structure. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index a87dbd3173d6a..e30dbb3cca7b4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -113,6 +113,9 @@ static int amdgpu_cs_parser_init(struct amdgpu_cs_parser *p, union drm_amdgpu_cs
 	if (cs->in.num_chunks == 0)
 		return -EINVAL;
 
+	if (cs->in.flags)
+		return -EINVAL;
+
 	chunk_array = kvmalloc_array(cs->in.num_chunks, sizeof(uint64_t), GFP_KERNEL);
 	if (!chunk_array)
 		return -ENOMEM;
-- 
2.53.0



