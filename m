Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623859;
	b=pzno47fNkgSjTnKvCJ9X1gFhf/khQs2iMFdDuqOJUla3pvEXUaMb0fDXcK1eEokUQrYH
	 qvGcKaCjWvjN1T0CK0MPlySSDag82AGqmW6AFm5LPzhLqh2ncqN5HJbe22hpenISgsIMy
	 ary2JR3G+3tRa2zatNC9CWAT8lls95YDRvdbdcifdFnaOk3rD7+NOLi4qu3MqmBDOBN3p
	 uwOjAp2Wa5GmfZH/W77RJNwKWJBr6SJOdVtk+Ihpi1dyhJEEp83YFnLFqjsskghFtvrc2
	 rKo9sxUaj3lDy/L9wX/0sRovmhaZy9iiMzcEyu1s/rMvJGqvbWhIOxCnUvfy7QAByEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rkIYqCLjvNqHyFze3Jb39G+qou7f39BFMIUBHeHdX3c=;
	b=pA9ekXKqtU81WgLqi6srPNvY/LJcMV88DgD/9qqeyGscbSCcP4hjnoHK40OIQqb3YDQf
	 9N04B8SeVrWNUiZD7/K9QzbcobLmT1KzC+97OOopFqqyHA0Xcz5k9Y8cvA5hKxKw5I25n
	 QmHnL6Arf70wop5Q0S6wBpgHCV75cEpG1PMKZjBIP2JeQ9Jw5mpNrZRpg4RiGUvYPsupE
	 SiFccD5ZVBzzu9zEuQYNF1TB1gS/J6vY0bs6R4J0COTUDVMXBzmsAEoE2KhkNqo5QGzBy
	 2UWYdNL8dustLH8mk/9PGFIsjqVomr0ei0SiyCYylvYINGy4lVlECr698zhdfxzpBtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U+tFJL6y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C266606A326;
	Wed, 25 Nov 2026 16:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U+tFJL6y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3821F000C4;
	Wed, 25 Nov 2026 16:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623859;
	bh=rkIYqCLjvNqHyFze3Jb39G+qou7f39BFMIUBHeHdX3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+tFJL6y5SwN15U+1YUjYvy78H5PbO7lTpJE712PkbPzvlSKyNBJa6D5gTQrNdqD1
	 9U0YKgKBsxrtuBwY+lVAaLilI+TKbMbKQJqYXDMsWeBwYIYYYzFvlnoMoXAUUBGEgz
	 1NbI/nM/oa0/l1fuXFBNZtyjVV4owNs4mYJvyW30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Riana Tauro <riana.tauro@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.18 982/990] drm/xe/xe_survivability: Remove unused index
Date: Wed, 25 Nov 2026 15:39:09 +0100
Message-ID: <20261125143844.980738522@linuxfoundation.org>
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

From: Riana Tauro <riana.tauro@intel.com>

commit fb084e4183e1d79ead103265cafc4b6bc0ecba03 upstream.

Remove unused index variable and fix for loop.

Fixes: f4e9fc967afd ("drm/xe/xe_survivability: Redesign survivability mode")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/intel-xe/20251210075757.GA1206705@ax162/
Signed-off-by: Riana Tauro <riana.tauro@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20251218105151.586575-5-riana.tauro@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_survivability_mode.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/xe/xe_survivability_mode.c
+++ b/drivers/gpu/drm/xe/xe_survivability_mode.c
@@ -120,11 +120,6 @@ xe_survivability_attribute *dev_attr_to_
 	return container_of(attr, struct xe_survivability_attribute, attr);
 }
 
-static u32 aux_history_offset(u32 reg_value)
-{
-	return REG_FIELD_GET(AUXINFO_HISTORY_OFFSET, reg_value);
-}
-
 static void set_survivability_info(struct xe_mmio *mmio, u32  *info, int id)
 {
 	info[id] = xe_mmio_read32(mmio, PCODE_SCRATCH(id));
@@ -136,7 +131,6 @@ static void populate_survivability_info(
 	u32 *info = survivability->info;
 	struct xe_mmio *mmio;
 	u32 id = 0, reg_value;
-	int index;
 
 	mmio = xe_root_tile_mmio(xe);
 	set_survivability_info(mmio, info, CAPABILITY_INFO);
@@ -149,13 +143,12 @@ static void populate_survivability_info(
 			set_survivability_info(mmio, info, POSTCODE_TRACE_OVERFLOW);
 	}
 
+	/* Traverse the linked list of aux info registers */
 	if (reg_value & AUXINFO_SUPPORT) {
-		id = REG_FIELD_GET(AUXINFO_REG_OFFSET, reg_value);
-
-		for (index = 0; id >= AUX_INFO0 && id < MAX_SCRATCH_REG; index++) {
+		for (id = REG_FIELD_GET(AUXINFO_REG_OFFSET, reg_value);
+		     id >= AUX_INFO0 && id < MAX_SCRATCH_REG;
+		     id =  REG_FIELD_GET(AUXINFO_HISTORY_OFFSET, info[id]))
 			set_survivability_info(mmio, info, id);
-			id = aux_history_offset(info[id]);
-		}
 	}
 }
 


