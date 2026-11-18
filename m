Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032199;
	b=jsEFkADmA8z0s7JXCx022moHcA1edgjSYkV5LqhFp7l8vKDieWC6weZwvelhthUmN7v8
	 gb4y3/iKzexkWWQ0smtDvGetpAwalpO3sQtyICrGeJzro9Mc19BhVKIynsTjfsaD+O8h9
	 TZUWaLDE/28lde5oVvxVuRWLFMAa5J9xQYNfUZ6SQaXQC6rgg7ihUIvQpQl6jBeHf9UPJ
	 /09IzK9I36OTaNtk+rLl9imaWTb691w9BMX1sy6zxJQ3X2RtDEFoeH2gL4HxinJm5Hky+
	 pfUVtrG+kOTbVEu9S+miEaT0bD6CMGjCqwd0D6womq2FqZCWRwg5j7LLcGWyb7Y09sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VFFXkAtTNklfwwqr0kB2pVyGxUkRFhp3HarRb2Cn5uo=;
	b=yMhpG/OIpeJPdil2Uf/clwd0pJCJAE+PTkt7lMWbCDL7zRZOcxRafaK1v+63haddPy4G
	 O6tW67+u8cyLfvAI+lafPtfmCIBhLErPqAAzkUU+3lqXPj/D+4Z1b9VXgA6mkSMtkWbCT
	 s8wWdon9CdGfp9p3fEmIyj4TRe6yiFNDiQYTYTwYHXa8+EkAgWXkOMTIc3yZSz/7dtA3c
	 2wOjIFziy8HaPYdMICAq9oUWLQAyGIdWezLaCQElbUsWGwTKt/ExADGXSsKcmjvB6yXr0
	 U86y50c54ILJ/QnsIa4Ig5lOXDWQRihHFZm5KF0WGYdOeZiKuldm9WNifVEo6p8PTyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZmU+lO2y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7402606A320;
	Wed, 18 Nov 2026 20:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZmU+lO2y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0821F000C8;
	Wed, 18 Nov 2026 20:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032198;
	bh=VFFXkAtTNklfwwqr0kB2pVyGxUkRFhp3HarRb2Cn5uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZmU+lO2yONVzRiUUw7hcyu1xeYL/4ecdkDn7UNmcGsA9Y/InVbGcu2ZaDr8WqsP99
	 ELxKFJxnO2wg+tJMTUYpqa2zvP0N80v867Tz5QtXs5g5oeE/NT+80ON/gU8eL1vz7x
	 0x2UlkU3+ag0S0srWFIeSDOsysBiQ9gYIjB1UNmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1286/1756] ASoC: Intel: avs: Prevent module info underflow
Date: Wed, 18 Nov 2026 15:56:53 +0100
Message-ID: <20261118150100.753945775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 05c2975b4267246219e7aead0467626107e204e9 ]

Typically modules information is first initialized when loading the base
AudioDSP base firmware and then expanded when loadable DSP modules are
requested by platform-components, see avs_component_load_libraries().

While theoretically not possible in a production scenario, there is no
reason to continue the IDAs preparation if an event caused the newly
obtained module information to be smaller or equal than the existing
information.

Fixes: c1a427e8da93 ("ASoC: Intel: avs: Firmware resources management utilities")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261015190240.729793-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/utils.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/avs/utils.c b/sound/soc/intel/avs/utils.c
index 81f9b67d8e293..05d7142a49246 100644
--- a/sound/soc/intel/avs/utils.c
+++ b/sound/soc/intel/avs/utils.c
@@ -118,9 +118,11 @@ avs_module_ida_alloc(struct avs_dev *adev, struct avs_mods_info *newinfo, bool p
 	int i;
 
 	if (!purge && oldinfo) {
-		if (oldinfo->count >= newinfo->count)
-			dev_warn(adev->dev, "refreshing %d modules info with %d\n",
+		if (oldinfo->count >= newinfo->count) {
+			dev_warn(adev->dev, "modules info underflow, old: %d, new: %d\n",
 				 oldinfo->count, newinfo->count);
+			return -EPROTO;
+		}
 		tocopy_count = oldinfo->count;
 	}
 
-- 
2.53.0



