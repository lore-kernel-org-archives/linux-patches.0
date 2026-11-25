Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621844;
	b=dJfMaUe9XvLQrhRX6uPpz2o9fyMEXJSCrkn9U69h/tQYR+XcmOkmJGnPDLCorp7/ZX4k
	 vK8bj4BKJfhNqp5CsoxODsV8tvcrXVuaClG9MshUOandP3aXDdaaHzn6+zeH8VEAbFAv1
	 SUjtnbii9UfztSVYwRxNTslQOdbgJt4RxoPF2SV8FCM5fNuW2JT/rLjHn55oVdRy0HIsS
	 J/YGWqvVRXk0veQcDmjJvmgDA9AG5mz27O43M4khZI88alYkRPAIvJx+ixxprFOqr7VDz
	 lHpLz7HmU1TqqU0Y4TZby8hnfkfBa83mZe6yRw/YmCa82sckGn+E1ZXTLL2pT24ZUlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VQVeupLPQdZmb/ffHKxy9XNdjodPYODf1bbGx5H1iHo=;
	b=AiTbU+/+chYkifvJ0sVADu5g3BhYilw6jaeci11JwDMruv0z+XLEaH5k2mYMfIDXuYrB
	 m4wYm5N/pz+4yLdAm6OAgFE3Q24l5/vJW0rZba3Rr6SSRt03Fv5Bc8MZ3trMUVuPlF7RX
	 9+4MINc/KXq2nhS0UnRet/x+Z+TmfRV4hBtrPcd+W19da7ZVnA0i+LA/m7dd3WVhxyQRV
	 LeMCGRT0AymVmXIVtfYJ0iUfDxWzYIhV9N5I7TePQc05VsLiVquRs8KMGoUt+ENYGXe5t
	 yjOzEBGRrddMXMFvQkSQI5pj4N9MccEEuC8IOhalqLXpoILnqTKT8rshKvQotKa+6SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sTJ9Lpue;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32834606A32C;
	Wed, 25 Nov 2026 15:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sTJ9Lpue
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547781F000CA;
	Wed, 25 Nov 2026 15:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621843;
	bh=VQVeupLPQdZmb/ffHKxy9XNdjodPYODf1bbGx5H1iHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTJ9Lpuew5c297mt/afRZv4KdWJZyWHASQHqxrlclK9v/4USZOkCT6rrYRQISod+Q
	 srcOW87EYfRmqd10Kabb/bA7OfXfvQqpYAfOUKk9dyoczwnByF4DgjpxDZcsmQSM9C
	 Lcy53VM/V+FPmCnREA4sbSzjqiRpLT1bo2e2mH/A=
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
Subject: [PATCH 6.18 350/990] drm/xe: Toggle the D3Cold enable flag at runtime resume
Date: Wed, 25 Nov 2026 15:28:37 +0100
Message-ID: <20261125143830.291030845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 10c5d852cf2b9..75334fc1ac66a 100644
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -1057,6 +1057,9 @@ static int xe_pci_runtime_resume(struct device *dev)
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



