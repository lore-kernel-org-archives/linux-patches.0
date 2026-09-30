Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035AD3BE642;
	Wed, 30 Sep 2026 18:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794744; cv=none; b=pP+9HNChJ/53cTRgZuGfwtGRtl8tKc5ZZEDV6bz58+/WGfFbnqWJNUFHdhhJXKIFaR/F8GcxqGAOxbl/wjTZu5lKoZIZGEuvGJgvdckKm8sOEZwGjV9WBfABElr3umLVFeg+HpGH8vvELqM3HvFa+I5FdlECtWKOPM54pa6iUY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794744; c=relaxed/simple;
	bh=N1XF0KRBRO0QVMyVAsHcpwCQXgTqDEnLd6ir/juXL1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EC5dHzAIW8ARjgqQGOo9CGgC6PYKcW6L5fsQhzOwTQdHwESRm6O/gZIxk9nkpXoiRr38Rw8nC/welKHZcXwQXVFhIn9waQaj+TKPHr4BbFFMkcJpo0cyj+opHHZ2TzW+me/XH3gGT/N8FTn+G86InWoLShjJN8WZwijE/E1Rwn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEjlP+ZM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEjlP+ZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFED11F000FF;
	Wed, 30 Sep 2026 18:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794742;
	bh=4K43yuId/XaBtDv0SMsG6Irk+oFu8tQVIj4pkXDcqRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JEjlP+ZM1rFvXvB0WmgGtHdf6AtEqn9SnP2vfTkfaCU89347zsz7GYABI3Fn+kBMS
	 xB1qWpRQB1xmyYHNd/t+g6u9ol4JWM8JyaUg1sEYYwqEIHI56Mk/y8rnp8CmQf3mae
	 OgYwTv+LDBwj9a34S0D9ZWwHmbPjEpBhyiIHhOdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0316/1193] drm/amd/pm/si: Dont schedule thermal work when queue isnt initialized
Date: Wed, 30 Sep 2026 17:16:40 +0200
Message-ID: <20260930152441.160764798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit f8922d5a946699fc2bdc7660e6778bd6726bf8b8 ]

When DPM is turned off with the amdgpu.dpm=0 module parameter,
the thermal work queue isn't initialized so we shouldn't
schedule any work on it.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bd018d36171a695952c6d391471c279c9e05c8b2)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index b95c3d01c659a..442b347dcfbc7 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -7670,7 +7670,7 @@ static int si_dpm_process_interrupt(struct amdgpu_device *adev,
 		break;
 	}
 
-	if (queue_thermal)
+	if (queue_thermal && amdgpu_dpm)
 		schedule_work(&adev->pm.dpm.thermal.work);
 
 	return 0;
-- 
2.53.0



