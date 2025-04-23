Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71554284B48;
	Wed, 23 Apr 2025 15:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421679; cv=none; b=QQASbXpMA+A364iVy4V14+lnUdaZEFYK6cp8DypVzj8bVVOFCGWJ2CbFE6YKPZMQi4gYQMVowsQ0bub8IE9fSf6b0HWnPmBFdidLJaVUk6A+hfYZL+dFokInedQNVl8FILN7ut9F0X0b8TweyLKGxrIlHFUTiz2yRKgQpGq4+eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421679; c=relaxed/simple;
	bh=wDbVIXKMBrjEa98uvxfMhW7DkqUAjegfAtai3wFmPP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtmToCJLpm7sA17cwBSaWS0hotOdfVeGbQIpm0xo6ABCRoYb2Pte+1s12TAyF7RdO56fIW4MdLDZl8wjAPieDAn5mjqv/gQh+tCbxkAakXpf7AZCGRUF54bAZsjFelprzs5MSDRTE3azjRAiRkrhvuWJEKyG2Z3MTKZRYwe7XNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRmSilSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRmSilSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05898C4CEEB;
	Wed, 23 Apr 2025 15:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421679;
	bh=wDbVIXKMBrjEa98uvxfMhW7DkqUAjegfAtai3wFmPP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRmSilSphrAMQlT6mmpNeVbws/vFGkXlkoshit1y/iJpZCvr4TeE2ziU67RSmIM5T
	 VgvzZisTH3yLpJJQyBIKBeokHcdaF6q3PU+V4Ce8F+XynATCsESPhBd6+d/fJzQVvb
	 TZkeYebztwvVbjWwM+3dIHhQ6NhnpxdIzI8labhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clint Taylor <Clinton.A.Taylor@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>
Subject: [PATCH 6.14 204/241] drm/xe/bmg: Add one additional PCI ID
Date: Wed, 23 Apr 2025 16:44:28 +0200
Message-ID: <20250423142628.872046622@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

commit 5529df92b8e8cbb4b14a226665888f74648260ad upstream.

One additional BMG PCI ID has been added to the spec; make sure our
driver recognizes devices with this ID properly.

Bspec: 68090
Cc: stable@vger.kernel.org # v6.12+
Reviewed-by: Clint Taylor <Clinton.A.Taylor@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250325224709.4073080-2-matthew.d.roper@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit cca9734ebe55f6af11ce8d57ca1afdc4d158c808)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/drm/intel/pciids.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/drm/intel/pciids.h
+++ b/include/drm/intel/pciids.h
@@ -847,6 +847,7 @@
 	MACRO__(0xE20C, ## __VA_ARGS__), \
 	MACRO__(0xE20D, ## __VA_ARGS__), \
 	MACRO__(0xE210, ## __VA_ARGS__), \
+	MACRO__(0xE211, ## __VA_ARGS__), \
 	MACRO__(0xE212, ## __VA_ARGS__), \
 	MACRO__(0xE215, ## __VA_ARGS__), \
 	MACRO__(0xE216, ## __VA_ARGS__)


