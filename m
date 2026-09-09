Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EEE57268C;
	Wed,  9 Sep 2026 14:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962970; cv=none; b=EBxhVXoHBobjMq19gYMhG0P1Qux/qAUiJu8DF2M6iRQefhsZTt9Suzu9G1lo6RKk3EWYwrl1LeS0/4AB6j/RPl5r6SimzDyioFchv2PA66yjX0/8y+6Hhh5v/v9fs7sfQTLU8MhHtMyEFG8YNlnXQezkDuUWdK88Q203gciwfwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962970; c=relaxed/simple;
	bh=FfZVS42tDnedwB/HkrDqODzTiIHXmWGymnsg6lvVet4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VxsMobcNpkMOD/9RA5oCJ92PNjNj+Y5Z80M3yDWvaFjFLH22qJCaGekOhFyv/G5G3ey+1ZlHblpu8Be66xv9UsVg1dSAbZYNdk5JDy+FeYC7HYxFPRMIRDMVmqBFoPTITd+3/dbusg1VXeEocwAL9Us6AdMtDIgTs2M2DGL4c1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiS40j32; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiS40j32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316501F00A3D;
	Wed,  9 Sep 2026 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962968;
	bh=DMfa7pHF3p3FcvTo9kn43BOm7WEVtsohbs4Ek/hpFEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qiS40j32v9YnOpU/Ct+bTl05szCAnkR+qOJa9RToUKcxb0d/H7VLZgcKeevenOKh1
	 jOHbqkHGXUBAB2PA+mnzqpLqPpPC3zE474KRdYBmvNZEIVIZeeJedtbfjf5wQRqtJF
	 t3fS0o0njlkonOiwJgcc24wp8DXpbBb2UPrFjF+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	stable@kernel.org
Subject: [PATCH 7.2 474/556] drm/xe/vram: report FLAT_CCS base misalignment
Date: Wed,  9 Sep 2026 15:42:34 +0200
Message-ID: <20260909134247.219974927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit 0e68c74e44da81a4599c52437ee1f63a2c234470 upstream.

So we can easily check if a machine had the CCS bug, when looking back
over bug reports where we have the same machine with newer kernel.

Example print for a machine with the CCS bug:

  FLAT_CCS base:27bbff800, aligned:no

v2 (Matt B):
  - Unconditionally print the base + alignment

Fixes: 37173392741c ("drm/xe/vram: fix ccs offset calculation")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: stable@kernel.org
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260902124117.918018-9-matthew.auld@intel.com
(cherry picked from commit d00b7f4f03bbeb2efad872f1686130e18c2b4141)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vram.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/xe/xe_vram.c
+++ b/drivers/gpu/drm/xe/xe_vram.c
@@ -90,6 +90,9 @@ static int get_flat_ccs_offset(struct xe
 		offset |= offset_lo << 6; /* HW view bits 31:6 */
 		offset *= num_enabled; /* convert to SW view */
 
+		drm_info(&xe->drm, "FLAT_CCS base:%llx, aligned:%s\n", offset,
+			 str_yes_no(IS_ALIGNED(offset, SZ_128K)));
+
 		/*
 		 * Everything below this offset is handed to the VRAM
 		 * allocator, so it has to be the *first* address the


