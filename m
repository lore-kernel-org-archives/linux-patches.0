Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C7C26B0AB;
	Tue,  8 Apr 2025 12:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115274; cv=none; b=AsIT5w8jF5126NpmTD6I+A5LCEyH+2AuzdWthvvcKZB79dzK6sJkgBPe6x+7lFuv38b0H9bya9q3boxHUxIe+x107X/YECzBkFfA/ij9wZ4sL0nEnCk99agk6KF6rLSZBFLKZkQMoqIShEOcXoTVBNOqZpD6mugWWB3fW1z9vaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115274; c=relaxed/simple;
	bh=YVPQs/Vgw0oX7QHJemnjoVJzprEN6AlXqz54YUxnRfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5YmDimlZipP/4EHUIs7Md7X7MTlFp61cWFWJD2pppCgb6u8xDhVSbn2F0HgVdjnDXF6lpYt3dgw4g3oOjYPZC/7BuiCIbEBY7pd+J2z3cbYNnqa924EqidgC/25y4nod7ZlRzyqKzGe8tHDZs9NFkW+KLmK2jFqOEe/ylzKpLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEQGP/Mn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEQGP/Mn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0E4C4CEE5;
	Tue,  8 Apr 2025 12:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115273;
	bh=YVPQs/Vgw0oX7QHJemnjoVJzprEN6AlXqz54YUxnRfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEQGP/MnZVrw/RjwvdzK6eyNuZT8HoGOe8GqYVbze3wJSpI5EVuhB6SMe6BTFCS/D
	 pUnsfNg8wf7NOHT/0nAvh0IBlyMf9VzMezhKY9B/QfcvjlDyO2KAS5RPRo43giVjmi
	 KDvosefLlAbYfIb/l6lHgBigrWFkX2bj8ncAz5Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 412/499] tools/power turbostat: Restore GFX sysfs fflush() call
Date: Tue,  8 Apr 2025 12:50:24 +0200
Message-ID: <20250408104901.498792336@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit f8b136ef2605c1bf62020462d10e35228760aa19 ]

Do fflush() to discard the buffered data, before each read of the
graphics sysfs knobs.

Fixes: ba99a4fc8c24 ("tools/power turbostat: Remove unnecessary fflush() call")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 08b1069d9ab54..634fb287716ab 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5836,6 +5836,7 @@ int snapshot_graphics(int idx)
 	int retval;
 
 	rewind(gfx_info[idx].fp);
+	fflush(gfx_info[idx].fp);
 
 	switch (idx) {
 	case GFX_rc6:
-- 
2.39.5



