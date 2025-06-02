Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D0B225388;
	Mon,  2 Jun 2025 14:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874932; cv=none; b=dnzH94OGbSDNRIRxe3KntvGivJe0KC2bNiXkGtrFI2l9QK1k4f4XdGeWFPAy+42AzacSVssW97sTjqCw2I5gEal+0PcLv2dEX0n2utKslVWeWKhtcFKKAjymG3fqHIIsOs/Eyyfs2HnPgbmmfXy4kuJVRtPhYXlbNDdrlo7UEMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874932; c=relaxed/simple;
	bh=jzsqS2wX8lXaM7c2M28ILPetPD5yt67G0zAom1yMPLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4fzUNAcs5XkIiuuYpqm4VSQywg65pcaWp/bi3OEZkNJsxM1N5qw9KQ8xjnqAgGUExo96VvwoOFQ3gqGolxom1w3GfnTIMfwXpF+PNNusEIjud7N2RofMGOUPue0GIWllMCdhcBTw2bb0o0JzDDyH3x39CXzlA/eK+vMAX6koBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7uNJp3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7uNJp3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653EBC4CEEB;
	Mon,  2 Jun 2025 14:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874931;
	bh=jzsqS2wX8lXaM7c2M28ILPetPD5yt67G0zAom1yMPLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7uNJp3rR26cuPgMZWUoBPPSGGhCajzr7vJIc76Nrs8lQYPsVyjNzfLO3DP2cFZxp
	 53vb+60sHk+oB00w1hB6mnsIG1JMzsQaPj03t2mwvhx7puMk6Hj9DsXwOzlEridrBE
	 bbrjhbxesua5ycX8VkmSo+5CaHBh8+8qgPilGZQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"feijuan.li" <feijuan.li@samsung.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.4 180/204] drm/edid: fixed the bug that hdr metadata was not reset
Date: Mon,  2 Jun 2025 15:48:33 +0200
Message-ID: <20250602134302.721660415@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: feijuan.li <feijuan.li@samsung.com>

commit 6692dbc15e5ed40a3aa037aced65d7b8826c58cd upstream.

When DP connected to a device with HDR capability,
the hdr structure was filled.Then connected to another
sink device without hdr capability, but the hdr info
still exist.

Fixes: e85959d6cbe0 ("drm: Parse HDR metadata info from EDID")
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: "feijuan.li" <feijuan.li@samsung.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://lore.kernel.org/r/20250514063511.4151780-1-feijuan.li@samsung.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_edid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -4629,6 +4629,7 @@ drm_reset_display_info(struct drm_connec
 	info->has_hdmi_infoframe = false;
 	info->rgb_quant_range_selectable = false;
 	memset(&info->hdmi, 0, sizeof(info->hdmi));
+	memset(&connector->hdr_sink_metadata, 0, sizeof(connector->hdr_sink_metadata));
 
 	info->non_desktop = 0;
 }


