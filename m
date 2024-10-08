Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA911DE8A0;
	Tue,  8 Oct 2024 12:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391046; cv=none; b=j4+uea3t4+y8bK9gyG9EhihbuRw0aYuGOfZkoujqbvyX3l9ItqAcmYBpcCnr85TEaqIdCxu/Z37PS3AHI5/Oh6L1IQn7qcy748FKDMZBrkp5eerdki84dl/DaYyewbGdX49FgcsBWGPVxhywy8Em9wsHw+TLhx0jQWwKHCcJPLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391046; c=relaxed/simple;
	bh=/JT32A7u8KTIcd+E94FJ69emo1e22W0Tc5RwkUqF0dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snyMe96uaS7zv2BOxHRL2qHoFQ+i96ebmg4kfT1pkl+3ogEMUNEm37myAsF8RsLkR820tz2RqLxaO4tnotSrubC8FMxTlnc89dm8eFowGnDBUeLrv1eQqF3cFhSa1ApeNZrGounA7lRHYuh4MOLoCUcYCC8AsZJD1F7C9QVN4ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGycmua8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGycmua8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAF8C4CEC7;
	Tue,  8 Oct 2024 12:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391045;
	bh=/JT32A7u8KTIcd+E94FJ69emo1e22W0Tc5RwkUqF0dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGycmua8Hq2CxXd4FgIYuiMLd6gNr8z3XNrRi16ZIK4RuJmbciPPk63/KVPjMhiog
	 zfJL1+668ajAmoklgRt+NfdCFCxJjfZBeJNADiu7z/3GAJzeWq4MmDMt7inkG6GWDV
	 /ss6uujcUKoR+drzsIBsW+r1DffNe3oQOOi13RKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Gray <jsg@jsg.id.au>
Subject: [PATCH 6.10 474/482] Revert "drm/amd/display: Skip Recompute DSC Params if no Stream on Link"
Date: Tue,  8 Oct 2024 14:08:57 +0200
Message-ID: <20241008115707.165489287@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Gray <jsg@jsg.id.au>

This reverts commit 6f9c39e8169384d2a5ca9bf323a0c1b81b3d0f3a.

duplicated a change made in 6.10.5
70275bb960c71d313254473d38c14e7101cee5ad

Cc: stable@vger.kernel.org # 6.10
Signed-off-by: Jonathan Gray <jsg@jsg.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1267,9 +1267,6 @@ static bool is_dsc_need_re_compute(
 	if (new_stream_on_link_num == 0)
 		return false;
 
-	if (new_stream_on_link_num == 0)
-		return false;
-
 	/* check current_state if there stream on link but it is not in
 	 * new request state
 	 */


