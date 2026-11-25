Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624707;
	b=epjtxvh/z3oaxMluy0qbr9v1Mp/XWqFTZOusJZvqE2+kIivnNIVFjuVtTSX6BRZ7ZpUO
	 MFxsonhgppqGVoN8cCajG8BVP7dbWmLCmqwK/2C6jI3uywedHy8TZCKd0e6hvYXE41Dtr
	 U2P/q2cguvyiQ7TE5PRBqpB688tGLDT9a+g/JtGB/J2ldaBsATyZzNwDse8CRNMxoLDuU
	 zpdpjn+tHzkBip3ca98TLONV/4ZA18tv2AM1Pc65sDG7UemVsdIt8GoqpWKblVUqMFBS4
	 EgNmzL9Fj7bbPBe92O1vNg0LgPaGG0SCshssyueh0+kUJxrMkaqv7o5RNbzAUM5n4kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FgLrx1VkTwCldedVSWM/D9TkKOJMXGS1dk9uMKlkG20=;
	b=2wmAqQDsNfhhQMl8yLUJl5UoSLaXy8XHP2OPWKA2kkY2HrOLMIa19QhYr2xBOkt4JkMi
	 ayHGWZH7ChCA7W6iCiVstoTQu6HjkWXIr1ucHI/h6Ad36KsOdX7kh4lR27F+oz9ChIU4A
	 IJ3+69gzhJFytgfUiwsvUI83uMXTbu440NAsLjeeVTZPRXy/uN0fBONTq3grWV3wjDfnn
	 0oJWEb+R2xEGM1V5f9jgk8CxuAyJJp9VVqI1zGmyAs+I8NrYFmnQ4oYO/GKem+w07zlgq
	 A3g3qerFRuv5oWxAzz5BKzlKCsai4Ycl2rKbfr2T84f0rermulnx3S48NPmVfQYZiZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mJafwhpO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F70606A680;
	Wed, 25 Nov 2026 16:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mJafwhpO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559E61F000C6;
	Wed, 25 Nov 2026 16:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624706;
	bh=FgLrx1VkTwCldedVSWM/D9TkKOJMXGS1dk9uMKlkG20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJafwhpODAAQQrHfLVF99oHi0dmxrs9Qie02pKBbsqChrE1vu6nHs79H5m2U59CZZ
	 rMnYTBSl8lZC9FlfilEfTwtAhz/CPhiwz351RrfUadjvxaUIJkRorxGVW5NlLT0XK7
	 U5IqPnuCZIJvJPF9yhwPjdkdZwN22r4HaHXtleEA=
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
Subject: [PATCH 6.12 282/816] drm/xe: Toggle the D3Cold enable flag at runtime resume
Date: Wed, 25 Nov 2026 15:30:30 +0100
Message-ID: <20261125143855.735237496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9d807d9a0807a..27c11082958c3 100644
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -983,6 +983,9 @@ static int xe_pci_runtime_resume(struct device *dev)
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



