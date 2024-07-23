Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32462158A2E;
	Tue, 23 Jul 2024 18:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760261; cv=none; b=nB5iIIoIM1BY6DwhceOorqFQd5KbQ0+n8LyEWKNvsKr5mAgGzvBhQdujTmPeNU0e4opcdWngY6IBU/MogagXJM8cDglpDuQj8/syfleTVUQ1FaXh8KQJkc67/I1iUH8sKVOfIf2OCbkNdhLHLmfsc2c0ajkK0RKM87iNnqUxom4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760261; c=relaxed/simple;
	bh=VUV8s2L2IivgKtqGPYI36BsNqtL9cji1VEzdcliEaqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMMNMYjhONjQWsG6MhkVOneWHO6h6VCcbcuo4Ksn2RQ9WTZyzIlBDqhp0XaBfQevyNUUXFc2wbLZsPo3As3RadmFC/z78nEEpsKAK0EE6QGEHosVXoAF9V/xM+aAGTmn/JfgI8xEMgE8iZVxlhchTgZFL1BmIqoaM5urQ37Blwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iiQ3hfjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iiQ3hfjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBF2C4AF0A;
	Tue, 23 Jul 2024 18:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760261;
	bh=VUV8s2L2IivgKtqGPYI36BsNqtL9cji1VEzdcliEaqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiQ3hfjMQkQwt0zzdPBP9YGr7lgisuJ7S0w+Dy09qsrQIdESHprVQXraTiOA2XGxn
	 ar3m2y6aK+n4zQlzN8z8Ugm8bM9Dud7x/KQwtdcCD+MIZtCsWqVt71V2+Tz7077Mg2
	 UjrWDwcindtEkGwBY5Uix+rJ3KWwyHSEhELzoNYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Savin <envelsavinds@gmail.com>,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.9 156/163] ALSA: hda: cs35l41: Fix swapped l/r audio channels for Lenovo ThinBook 13x Gen4
Date: Tue, 23 Jul 2024 20:24:45 +0200
Message-ID: <20240723180149.499736082@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Savin <envelsavinds@gmail.com>

commit 0f74758c08fc711b45cdf5564c5b12903fe88c82 upstream.

Fixes audio channel assignment in configuration table for ThinkBook 13x Gen4.

Fixes: b32f92d1af37 ("ALSA: hda: cs35l41: Support Lenovo Thinkbook 13x Gen 4")
Signed-off-by: Dmitry Savin <envelsavinds@gmail.com>
Reviewed-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20240704211402.87776-1-envelsavinds@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/cs35l41_hda_property.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/cs35l41_hda_property.c
+++ b/sound/pci/hda/cs35l41_hda_property.c
@@ -118,8 +118,8 @@ static const struct cs35l41_config cs35l
 	{ "17AA38B5", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
 	{ "17AA38B6", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
 	{ "17AA38B7", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
-	{ "17AA38C7", 4, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, CS35L41_LEFT, CS35L41_RIGHT }, 0, 2, -1, 1000, 4500, 24 },
-	{ "17AA38C8", 4, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, CS35L41_LEFT, CS35L41_RIGHT }, 0, 2, -1, 1000, 4500, 24 },
+	{ "17AA38C7", 4, INTERNAL, { CS35L41_RIGHT, CS35L41_LEFT, CS35L41_RIGHT, CS35L41_LEFT }, 0, 2, -1, 1000, 4500, 24 },
+	{ "17AA38C8", 4, INTERNAL, { CS35L41_RIGHT, CS35L41_LEFT, CS35L41_RIGHT, CS35L41_LEFT }, 0, 2, -1, 1000, 4500, 24 },
 	{ "17AA38F9", 2, EXTERNAL, { CS35L41_RIGHT, CS35L41_LEFT, 0, 0 }, 0, 2, -1, 0, 0, 0 },
 	{ "17AA38FA", 2, EXTERNAL, { CS35L41_RIGHT, CS35L41_LEFT, 0, 0 }, 0, 2, -1, 0, 0, 0 },
 	{}


