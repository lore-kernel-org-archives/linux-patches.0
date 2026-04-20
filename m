Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0272832ED54;
	Mon, 20 Apr 2026 15:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699827; cv=none; b=mrLrJT27qfDtrdVj+FM9nR74ao3BUcQNpRRvKuR5FhCFhy0S1boNpjUvhQVx6/7wkh3ulAj2uYhT7hB+kTFci86kvLI/hn7oceZUFxU7MKhnQtbfNezC2QVv3M76gQASKl7TzKifiyMK1uztPr7p/zfXhleccyqE2hwmfgud7n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699827; c=relaxed/simple;
	bh=Hkn/1ibxDqRanRKXzlPtRd6CJ5ZxZKXTqpoxfm+FIeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+DwfVWLVn0WKetJcijEtpR8PoKu64weCJmLUuJFtGJuhwGdm5M+iW/gAh+LnQOaGdHhgdo4J933osP0EPQOc1DzzTAqxXN5xSgMa/boK0BMAx8owgekBlaSZ4ii3WTcXCuO9RMiPkfVwHvfAem6PKVliYr/W+2cqIzbJKdShFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USF/dAPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USF/dAPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F67C19425;
	Mon, 20 Apr 2026 15:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699826;
	bh=Hkn/1ibxDqRanRKXzlPtRd6CJ5ZxZKXTqpoxfm+FIeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USF/dAPJb5e05no8IVu+MmQzMGGkGvHwzSWpQIlRL2Efp4+VbIP9MLrsvA8zVZmTi
	 uE7vt86VkQ2MCqW3qu4YKXshAbOtPxojQKztujVZWLVoTGVKXfw3NbP9OdwRg4+LYY
	 SbJ0vEv/kfdvUrqIEFref0I4yo4mEUgekLtD3nSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clemens Ladisch <clemens@ladisch.de>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	stable <stable@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 13/76] ALSA: fireworks: bound device-supplied status before string array lookup
Date: Mon, 20 Apr 2026 17:41:24 +0200
Message-ID: <20260420153911.305275121@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 07704bbf36f57e4379e4cadf96410dab14621e3b upstream.

The status field in an EFW response is a 32-bit value supplied by the
firewire device.  efr_status_names[] has 17 entries so a status value
outside that range goes off into the weeds when looking at the %s value.

Even worse, the status could return EFR_STATUS_INCOMPLETE which is
0x80000000, and is obviously not in that array of potential strings.

Fix this up by properly bounding the index against the array size and
printing "unknown" if it's not recognized.

Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Fixes: bde8a8f23bbe ("ALSA: fireworks: Add transaction and some commands")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://patch.msgid.link/2026040953-astute-camera-1aa1@gregkh
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/fireworks/fireworks_command.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/firewire/fireworks/fireworks_command.c
+++ b/sound/firewire/fireworks/fireworks_command.c
@@ -151,10 +151,13 @@ efw_transaction(struct snd_efw *efw, uns
 	    (be32_to_cpu(header->category) != category) ||
 	    (be32_to_cpu(header->command) != command) ||
 	    (be32_to_cpu(header->status) != EFR_STATUS_OK)) {
+		u32 st = be32_to_cpu(header->status);
+
 		dev_err(&efw->unit->device, "EFW command failed [%u/%u]: %s\n",
 			be32_to_cpu(header->category),
 			be32_to_cpu(header->command),
-			efr_status_names[be32_to_cpu(header->status)]);
+			st < ARRAY_SIZE(efr_status_names) ?
+				efr_status_names[st] : "unknown");
 		err = -EIO;
 		goto end;
 	}


