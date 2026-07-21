Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1C040312F;
	Tue, 21 Jul 2026 17:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653921; cv=none; b=AOOhj4kUV2lNz0+yieW+8Mi1ZsSOsIazCx0wajjJ/mC4Nq6qDNmZnB9U9scgGfog94Efv6dFkomVxPPMHviv09IkoQ+Bb2FbPUrRqOFEhBmUxBDQxqn7YQAUlnj7PvUPJLh+MexJVGNnmnO9sV+82QkYS/LhpoYH7OQS06Nc8ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653921; c=relaxed/simple;
	bh=7dx9PogDvJ9Pg9kHSyJeQqIN0syLPnSjAN1Mq8r+0b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KAv05JNHUbMEjlJ4YFZHwDnuoLGhV5G3YyRa1imApd+lSnS9PAYfedw/3aIS06PL47QyuueKRibIM3G3ySyE3MQN5kB319vnHmYNFSfu/aABQGyObStN4btR9YsxisW3OlPCXk3pOIova9V+b8jqpiVC1Nz/YQsk/z1HP2Nmeqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcLDgIPc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcLDgIPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA551F00A3A;
	Tue, 21 Jul 2026 17:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653920;
	bh=qQFXvlbATkCEIIvaHAQGFDS3HoPs+82Ddg9NjTt62X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rcLDgIPcooIL3Zh+N1OfYQiuYZ/bhsNmAsvqJT+d/943eEG3aToY58XsYORphbdXr
	 oRaFewIJIaO7YRYYadRbniUb0C9xOukUkqFdAnLBSVjK+UoXhQu5r3z/2WsA6Y19IU
	 eD1L0aov6Sf/DLt2wxb1v/q4hWaxxIHB4XqycXGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anas Khan <anxkhn28@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1508/2077] drm/xe: remove duplicate <kunit/test-bug.h> include
Date: Tue, 21 Jul 2026 17:19:41 +0200
Message-ID: <20260721152628.353238943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anas Khan <anxkhn28@gmail.com>

[ Upstream commit 91426ce50d14a49bde53b3ad1e48393556ba92cd ]

xe_pci.c includes <kunit/test-bug.h> twice, separated only by the
<kunit/test.h> include. Drop the redundant second include; this is a
non-functional cleanup flagged by scripts/checkincludes.pl.

Fixes: 6cad22853cb8 ("drm/xe/kunit: Add stub to read_gmdid")
Signed-off-by: Anas Khan <anxkhn28@gmail.com>
Link: https://patch.msgid.link/20260702112820.34675-1-anxkhn28@gmail.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 84ed5b0a925721aaf069d36e18a99db966ff4e80)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/tests/xe_pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/tests/xe_pci.c b/drivers/gpu/drm/xe/tests/xe_pci.c
index f3179b31f13e3a..8a32fb469147db 100644
--- a/drivers/gpu/drm/xe/tests/xe_pci.c
+++ b/drivers/gpu/drm/xe/tests/xe_pci.c
@@ -9,7 +9,6 @@
 
 #include <kunit/test-bug.h>
 #include <kunit/test.h>
-#include <kunit/test-bug.h>
 #include <kunit/visibility.h>
 
 #define PLATFORM_CASE(platform__, graphics_step__)					\
-- 
2.53.0



