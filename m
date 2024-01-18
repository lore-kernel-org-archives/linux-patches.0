Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2E9B65C;
	Thu, 18 Jan 2024 10:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575032; cv=none; b=seezQIrFfX65rWQ5xiw1v13yw1/mzJlQXC0FkHUdsw9fSIBTtrEEu9a0IDWso+IyilfwKpIwec+7C5YB8/sRa3C/Y0SpAWz7myuf3yDGayK+47Uo3aytqPY2L4oEN0Cs1TXXCYQjZyyIIT5yL0Z3E09IzlG69jgVqZr6k3SFY1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575032; c=relaxed/simple;
	bh=6oLFMEAuZ8KmEHGmUHlH7cCPOUB5FESx8R2aE2xZvAg=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=Iaduwta2NDNMLTenN1i8qA9K8IifDZuakjMJfxYXM7AY/SXvz4if69v3ukW9UFYu1MewTmQm2RKHujxxMjV5td336qtNbRtvUGjN4Ojz00ZhpIuVDoEGWmROMwYFgSDSPV/+Qrpn976hGeIU6dJWspTTEKuSy2ph9Er/pv4ksfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWiJIxvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWiJIxvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F37AC433C7;
	Thu, 18 Jan 2024 10:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575031;
	bh=6oLFMEAuZ8KmEHGmUHlH7cCPOUB5FESx8R2aE2xZvAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWiJIxvTwH9oGC0ogh4cLIo8YbkvpgDpft9EkDgo5On5rbHRAmMtYrrI9wr3ZX273
	 uD6l+Hb91F0CPDSnVaCfM/Ep2A4n6f+V21hGs2LNsQ0dOH/4StJImSecPtT2U6sxRg
	 JNSSE1VJd+pMTiDm3I5Qkjh7Wo+pPpbRkB7ezgR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dorian Cruveiller <doriancruveiller@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 05/28] ALSA: hda: Add driver properties for cs35l41 for Lenovo Legion Slim 7 Gen 8 serie
Date: Thu, 18 Jan 2024 11:48:55 +0100
Message-ID: <20240118104301.421587013@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dorian Cruveiller <doriancruveiller@gmail.com>

commit ba7053b4b4a4ddcf530fa2b897e697004715d086 upstream.

Add driver properties on 4 models of this laptop serie since they don't
have _DSD in the ACPI table

Signed-off-by: Dorian Cruveiller <doriancruveiller@gmail.com>
Cc: <stable@vger.kernel.org> # v6.7
Link: https://lore.kernel.org/r/20231230114312.22118-1-doriancruveiller@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/cs35l41_hda_property.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/pci/hda/cs35l41_hda_property.c
+++ b/sound/pci/hda/cs35l41_hda_property.c
@@ -71,6 +71,10 @@ static const struct cs35l41_config cs35l
 	{ "10431F12", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
 	{ "10431F1F", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 0, 0, 0 },
 	{ "10431F62", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
+	{ "17AA38B4", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
+	{ "17AA38B5", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
+	{ "17AA38B6", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
+	{ "17AA38B7", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
 	{}
 };
 
@@ -379,6 +383,10 @@ static const struct cs35l41_prop_model c
 	{ "CSC3551", "10431F12", generic_dsd_config },
 	{ "CSC3551", "10431F1F", generic_dsd_config },
 	{ "CSC3551", "10431F62", generic_dsd_config },
+	{ "CSC3551", "17AA38B4", generic_dsd_config },
+	{ "CSC3551", "17AA38B5", generic_dsd_config },
+	{ "CSC3551", "17AA38B6", generic_dsd_config },
+	{ "CSC3551", "17AA38B7", generic_dsd_config },
 	{}
 };
 


