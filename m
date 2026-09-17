Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA6D3D9DA2;
	Thu, 17 Sep 2026 17:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665154; cv=none; b=ai5+bxfBf+jVnxGoDF3nyaQG0DkSFz7W2dOWBMuvBv7FbXBO7UVo6hyxlhB92vbFbPvyoJBB6GrFpFWtQhU9jQ0lP7eu2WjuuZXzs2SZr38Fz7/+oH2SqhufY3Bqc2CoxfmslXuzwXp+2x19Lz47UyiAp8x/ded5lWlyFbX7Y8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665154; c=relaxed/simple;
	bh=cuQAneHkCL8q8JfiI+j7JYAtK88FEAgayYvmoVwEm1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyEr0PI4hLL8Y3Sx2FWNO1AsreZBPDrvm6TU0lXlgfulshMxPHOBuMRw2ozUg5vPX6C7yFgHFNDS5XDHCXQ+LHQNkSjsebIDTRM9F5jQk5KABP3j/s51bL1prDzx5X4fJQ4KywWxk0jl0a/Y6uOabiQ428fD8db4dODoZuSm17Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRZoaAsa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRZoaAsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA541F000FF;
	Thu, 17 Sep 2026 17:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665153;
	bh=1t/l9h2KWyL+PjjUc30TZEjjKc6fwQVuPFWA/c8yhIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRZoaAsa2k35jZ8Tw+ee6MKkCuLtTUysZPj6DLYB9ZrjAptQ0raNMoABmAmutnCW0
	 pK+JxDQSgfYXq7J4MSpFQrGH0Fa2htRBTNuiahuDFkgoNUo97qGCOeANl5CC4i66Cr
	 I8R6wT9RcA23GPJz61BisXxMT1YLicG4r8aV4lc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Luo <luoliang@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0611/1250] sched_ext: Fix nonexistent field in sched-ext.rst example
Date: Thu, 17 Sep 2026 16:06:46 +0100
Message-ID: <20260917151608.437272540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Luo <luoliang@kylinos.cn>

[ Upstream commit 4fb8d6379d2c7ceecb2b3e111954d29089d59492 ]

The ops.exit() example in sched-ext.rst reads ei->type, but
struct scx_exit_info has never had a type field - the exit reason is
exposed as ei->kind since the struct was introduced. A scheduler
written following the example fails to compile with

    error: no member named 'type' in 'struct scx_exit_info'

Use ei->kind.

Fixes: fa48e8d2c7b5 ("sched_ext: Documentation: scheduler: Document extensible scheduler class")
Signed-off-by: Liang Luo <luoliang@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/scheduler/sched-ext.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/scheduler/sched-ext.rst b/Documentation/scheduler/sched-ext.rst
index a72461b1c9305..09f28db3bc8d2 100644
--- a/Documentation/scheduler/sched-ext.rst
+++ b/Documentation/scheduler/sched-ext.rst
@@ -181,7 +181,7 @@ optional. The following modified excerpt is from
 
     void BPF_STRUCT_OPS(simple_exit, struct scx_exit_info *ei)
     {
-            exit_type = ei->type;
+            exit_type = ei->kind;
     }
 
     SEC(".struct_ops")
-- 
2.53.0



