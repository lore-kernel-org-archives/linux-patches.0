Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311C3285075;
	Tue, 17 Jun 2025 16:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178792; cv=none; b=p/QFccz7UhrmR0p6tvTWa4KpXx5iQ7eGY55M4Rrg40akxzamTKtxrwTsvRQgfxA1Ul8vNvYN0wuqILXwuGuFhX+jM7AruL0oa9YOiIiwv9jUAD7g/U7oHGGAb93H0uQg/g3y6UpwWNo8TC5fpNJO8JZDmBE4+mvFKFrH+O0OAEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178792; c=relaxed/simple;
	bh=NIcr+fxy+k4SAe1WjIQLAGq7Ww93ESH498ZagjswnD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MdWZI0KfReU0q/bnbmMTj5LS95v3yCtZEJ1owjsdZJqk2CxLBYmG3vMpDsgMSgTrsggXazyXek4AxpriZZQhYdv8H9eohnnSvFmeeQLimcjNNsuZYabe97711wVOz8R0S1iznjNOZ6vPGSk3FyFoFqd7/KPER7zghfTVzdn9C2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJKCCFF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJKCCFF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C23C4CEE3;
	Tue, 17 Jun 2025 16:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178792;
	bh=NIcr+fxy+k4SAe1WjIQLAGq7Ww93ESH498ZagjswnD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJKCCFF4aocA+sfgXwhJuwQPjk6ZXoIbvk/zDJHGoeQwulmFZvm3DATzor4ibHjYd
	 WpnZnJ1CN8WhnXzL6EGuPKuGHp0QFvGETtPYjcomCcIbDmRy16gDiZSv/FM2vhKhmR
	 rSKGEjy3d9HXGhEjPipbC4rJKlKOrPSvwjkMuMak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 556/780] drm/xe: Make xe_gt_freq part of the Documentation
Date: Tue, 17 Jun 2025 17:24:24 +0200
Message-ID: <20250617152514.141606163@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

[ Upstream commit 55f8aa083604ce098c9d6a0911c6bcde15d03a80 ]

The documentation was created with the creation of the component,
however it has never been actually shown in the actual Documentation.

While doing this, fixes the identation style, to avoid new warnings
while building htmldocs.

Fixes: bef52b5c7a19 ("drm/xe: Create a xe_gt_freq component for raw management and sysfs")
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250521165146.39616-3-rodrigo.vivi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit af53f0fd99c3bbb3afd29f1612c9e88c5a92cc01)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/gpu/xe/index.rst      |  1 +
 Documentation/gpu/xe/xe_gt_freq.rst | 14 ++++++++++++++
 drivers/gpu/drm/xe/xe_gt_freq.c     |  2 ++
 3 files changed, 17 insertions(+)
 create mode 100644 Documentation/gpu/xe/xe_gt_freq.rst

diff --git a/Documentation/gpu/xe/index.rst b/Documentation/gpu/xe/index.rst
index 92cfb25e64d32..b53a0cc7f66a3 100644
--- a/Documentation/gpu/xe/index.rst
+++ b/Documentation/gpu/xe/index.rst
@@ -16,6 +16,7 @@ DG2, etc is provided to prototype the driver.
    xe_migrate
    xe_cs
    xe_pm
+   xe_gt_freq
    xe_pcode
    xe_gt_mcr
    xe_wa
diff --git a/Documentation/gpu/xe/xe_gt_freq.rst b/Documentation/gpu/xe/xe_gt_freq.rst
new file mode 100644
index 0000000000000..c0811200e3275
--- /dev/null
+++ b/Documentation/gpu/xe/xe_gt_freq.rst
@@ -0,0 +1,14 @@
+.. SPDX-License-Identifier: (GPL-2.0+ OR MIT)
+
+==========================
+Xe GT Frequency Management
+==========================
+
+.. kernel-doc:: drivers/gpu/drm/xe/xe_gt_freq.c
+   :doc: Xe GT Frequency Management
+
+Internal API
+============
+
+.. kernel-doc:: drivers/gpu/drm/xe/xe_gt_freq.c
+   :internal:
diff --git a/drivers/gpu/drm/xe/xe_gt_freq.c b/drivers/gpu/drm/xe/xe_gt_freq.c
index 604bdc7c81736..985efbc685286 100644
--- a/drivers/gpu/drm/xe/xe_gt_freq.c
+++ b/drivers/gpu/drm/xe/xe_gt_freq.c
@@ -32,6 +32,7 @@
  * Xe's Freq provides a sysfs API for frequency management:
  *
  * device/tile#/gt#/freq0/<item>_freq *read-only* files:
+ *
  * - act_freq: The actual resolved frequency decided by PCODE.
  * - cur_freq: The current one requested by GuC PC to the PCODE.
  * - rpn_freq: The Render Performance (RP) N level, which is the minimal one.
@@ -39,6 +40,7 @@
  * - rp0_freq: The Render Performance (RP) 0 level, which is the maximum one.
  *
  * device/tile#/gt#/freq0/<item>_freq *read-write* files:
+ *
  * - min_freq: Min frequency request.
  * - max_freq: Max frequency request.
  *             If max <= min, then freq_min becomes a fixed frequency request.
-- 
2.39.5



