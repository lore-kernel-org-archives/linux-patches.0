Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618833;
	b=rQCdePnEHJuo7PvfP5L0E9vc/UlgT8pe4p+sRYEtX/p9KJKn3nKUxYvV0aM0YHLzGhok
	 jv8RpRrEUIjhu6MzgsYcbKQde+xQEdww8q1dGtKFo05yGRZoO0fYsckkCKVpksK1bsjHg
	 ph+AaHaHLAI/j2lMDbOVdzEMkl2IC72G9UIXj7Mcoh2rH7bxFv/vFP6rhvddqy5uB28mM
	 pBbHmn+438D8DRCrk7vJd9HyaGGNQy4QDBnf9iyvGz4HyLiodjp4jmI3YuSzx+RQo42Pi
	 ZxEaABEOVq2WHSMZ2JIZ/SP0rnQoxurljzMZt9VIV4gfyVPo5gtuflpSYHlI6BEopYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R9n+PI8u23uafc2eRpnPZVYTewmcqTC00Ad3IiWnEAg=;
	b=R2wSgL+0t5qwdv8EeuqU43XkppU/Jmp7rjNRoo4i04MCKg33DdlA7vEVh4b3/VbT9ZrU
	 pg8gJfIU1mPrYYRfBeHRK6Q51ksl+LqFH28ul9TnLTqmz6n/crE6pyK6ZmW2asZQpVdWs
	 rSwIbtN1q1BMKnI9JIOxOaaoTz3LOqK/z5gW+zsT/yE9leBahFMCMoFseXbW9TzYomtXx
	 Km76UU5qxUVQbgACsVEjh+DRd2+2nTcDECMLP5T/tTHefeSCCKy4CwONbe9uBXHZjxuKX
	 f0pvBvXzNHbxEoVWEC2B+KUo4v0LP45c9A5NwqIX5xR9TEjEvMR0vXPIh4wqvt8JMig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhiiUETm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FED606A327;
	Wed, 25 Nov 2026 15:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhiiUETm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41761F000C6;
	Wed, 25 Nov 2026 15:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618833;
	bh=R9n+PI8u23uafc2eRpnPZVYTewmcqTC00Ad3IiWnEAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhiiUETmyIsIq4X4Jm4yAf7YFSYrNSnR8gjlEHl6IHwnKTtneFj9W8dN50sfK8Q10
	 wfRVCwiB4eh7uQokTyVSBXGDmbxT8fZwyF75DK7P/wnrix+TZINc0qoQtOxDo17r5M
	 BU0HrVav6U7EuBhv2Tf5IhZJeX78D1qR03UdKTck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Karthik Poosa <karthik.poosa@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0401/1005] drm/xe: Toggle the D3Cold enable flag at runtime resume
Date: Wed, 25 Nov 2026 15:28:59 +0100
Message-ID: <20261125143831.140366597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit e42459b16cbf1cbcebfc1ab406140cca204fd831 ]

We enable this flag during runtime suspend, need to set it back to
false early during resume to maintain consistency in pci driver's
internal state. d3cold_toggle() updates the root port's ability
to go into d3cold via the dev->no_d3cold flag. With this patch, we
are ensuring this internal state remains consistent with that of
the endpoint.

v2: Clarify the commit message (Matt Auld)
v3: Add fixes (Karthik Poosa)

Fixes: f026520367be ("drm/xe: Only set PCI d3cold_allowed when we are really allowing.")
Cc: Matthew Auld <matthew.auld@intel.com>
Acked-by: Karthik Poosa <karthik.poosa@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Reviewed-by: Karthik Poosa <karthik.poosa@intel.com>
Link: https://patch.msgid.link/20261027174351.619929-6-vinay.belgaumkar@intel.com
(cherry picked from commit e994e0f1ba52e4be3607ba7f952a8d835f1f6563)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_pci.c b/drivers/gpu/drm/xe/xe_pci.c
index 5d7a0b403ac0d..93438a670ae44 100644
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -1404,6 +1404,9 @@ static int xe_pci_runtime_resume(struct device *dev)
 	struct xe_device *xe = pdev_to_xe_device(pdev);
 	int err;
 
+	if (xe->d3cold.allowed)
+		d3cold_toggle(pdev, D3COLD_DISABLE);
+
 	err = pci_set_power_state(pdev, PCI_D0);
 	if (err)
 		return err;
-- 
2.53.0



