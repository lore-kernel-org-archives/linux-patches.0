Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B79729BD87;
	Tue, 26 Aug 2025 11:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207403; cv=none; b=tDo2fWnAi1t2QQm1FrMcMcx3d6eFJdDjHUFW3RDxEgDidpyRz/Gy5RTrp/Yq7w0hUME4nwDIBU3kqGqrsloYzPx1nfwdCc81czz1kQ0UTi2NxmAdMEViF93KbbD4NwotVP3GS0dGM9aiSjgY1fNjYEllcEO7dP8KsT0cN+phDMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207403; c=relaxed/simple;
	bh=X1BslSxcTA124aasO/YzMS8UjycengwLD2l3MTTeL0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnRvhyGWOh6F/aauteBolL4/yRYgzq7YbpMfLdrop6QTITiOlGo9GK08aC+Ygjb6KoiOrc22KOf4mQROpxGIS2BofTyWC6ZyNquBDHdTTpAmfnkI6fU2KRfZvnLdMkoRTG1TlmPMS4hA2z6CqZd921VZvISjhqers+81uAhqkT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHT9XfY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHT9XfY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633AFC4CEF1;
	Tue, 26 Aug 2025 11:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207402;
	bh=X1BslSxcTA124aasO/YzMS8UjycengwLD2l3MTTeL0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KHT9XfY7m7YmKE7UGnfPcZmxn2pKm1SjuBUFEUmn96B8a0vEQrcKl8cimOhneDhbG
	 3I+uzt+qiPpRWQaQMpll5JLUj/aBAjUYHYLyDLEahSgpIkwpTkQMRAzvd9pllF+xsA
	 NvDtZkpmqAHKxU/VXLudJPZKbjeng7fqnbbVTYOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vodapalli, Ravi Kumar" <ravi.kumar.vodapalli@intel.com>,
	Shekhar Chauhan <shekhar.chauhan@intel.com>,
	Matthew Auld <matthew.auld@intel.com>
Subject: [PATCH 6.16 168/457] drm/xe/bmg: Add one additional PCI ID
Date: Tue, 26 Aug 2025 13:07:32 +0200
Message-ID: <20250826110941.527694527@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vodapalli, Ravi Kumar <ravi.kumar.vodapalli@intel.com>

commit ccfb15b8158c11a8304204aeac354c7b1cfb18a3 upstream.

One additional PCI ID is added in Bspec for BMG, Add it so that
driver recognizes this device with this new ID.

Bspec: 68090
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Vodapalli, Ravi Kumar <ravi.kumar.vodapalli@intel.com>
Reviewed-by: Shekhar Chauhan <shekhar.chauhan@intel.com>
Acked-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://lore.kernel.org/r/20250704103527.100178-1-ravi.kumar.vodapalli@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/drm/intel/pciids.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/drm/intel/pciids.h
+++ b/include/drm/intel/pciids.h
@@ -846,6 +846,7 @@
 /* BMG */
 #define INTEL_BMG_IDS(MACRO__, ...) \
 	MACRO__(0xE202, ## __VA_ARGS__), \
+	MACRO__(0xE209, ## __VA_ARGS__), \
 	MACRO__(0xE20B, ## __VA_ARGS__), \
 	MACRO__(0xE20C, ## __VA_ARGS__), \
 	MACRO__(0xE20D, ## __VA_ARGS__), \


