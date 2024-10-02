Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421111D0945;
	Wed,  2 Oct 2024 13:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876624; cv=none; b=c+BvZWfvficimVg4bc/XFHAGyUQRiK3xL2yhai6pyNWeuKYkiYK2a3gj/+aCK/TJJ1JwU/NtdP7x3bm+soZv8llRwE5oUuY1FGSxlksYLsedj7U2l+hLuxcOWLUXVvpJIuERd2vm+offORJuTOJsiIFoVRMjEBXpYvvmXcAnqPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876624; c=relaxed/simple;
	bh=IHeSiIDiWDO+qH9DiNLA6E5vLtfdBZd8G+Cg1ts4S+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8bFb8hoI18rrSpHjkgIPuhg/I+WohhBmwIRGytaAu1b6Kj6mJQXPZ8FvJjuOVnGjECXFJsE3mfGRLqnbaofi8wDVaVkbHd4UeVykNJ4e8ye9dQ2ZyU5y3nYJg4F1U0TyUFcOa/wPXgHUDODEOaTYtX+271TeAXaDow6WNhMLKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAkunSrS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAkunSrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CC8C4CEC5;
	Wed,  2 Oct 2024 13:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876624;
	bh=IHeSiIDiWDO+qH9DiNLA6E5vLtfdBZd8G+Cg1ts4S+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAkunSrSb5i/dCj1RqNchmOJSRjsQKfk1vGtK9xMM8HrXyl7YXDzlSR9FGQ65OplC
	 7DAkrkOTSiSw59qpPOzT3nCspbHFDht9NlAqZG9s37JsI4HHmmoOG0QGbgw+rmkSHp
	 HgibsMZ9Uk++w5c0gHc32Jq2JbF16Lb55IVBYTBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Dominik Grzegorzek <dominik.grzegorzek@intel.com>,
	Mika Kuoppala <mika.kuoppala@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 508/695] drm/xe: fix engine_class bounds check again
Date: Wed,  2 Oct 2024 14:58:26 +0200
Message-ID: <20241002125842.759141762@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit 23ab1cb6591dba7c97b65eb407cd71147bd878b8 upstream.

This was fixed in commit b7dce525c4fc ("drm/xe/queue: fix engine_class
bounds check"), but then re-introduced in commit 6f20fc09936e ("drm/xe:
Move and export xe_hw_engine lookup.") which should only be simple code
movement of the existing function.

Fixes: 6f20fc09936e ("drm/xe: Move and export xe_hw_engine lookup.")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Dominik Grzegorzek <dominik.grzegorzek@intel.com>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240812141331.729843-2-matthew.auld@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_hw_engine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_hw_engine.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine.c
@@ -1153,7 +1153,7 @@ xe_hw_engine_lookup(struct xe_device *xe
 {
 	unsigned int idx;
 
-	if (eci.engine_class > ARRAY_SIZE(user_to_xe_engine_class))
+	if (eci.engine_class >= ARRAY_SIZE(user_to_xe_engine_class))
 		return NULL;
 
 	if (eci.gt_id >= xe->info.gt_count)


