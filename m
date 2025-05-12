Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2C01519B8;
	Mon, 12 May 2025 18:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072868; cv=none; b=J2nmzqsFzKzcauDvmvRmPMty8cKy/mGGk6ikGjL0ytEtfzmBjL8hrm3TdKdIEhlRiGAvNP3AP2HoyhI4lTMXVjdxzH9jiq5eAe3UhAOoA/cK2q4YM5JQi62lKgMdkFNNrwKJOge+3hPyD2Ng3NMknlIBJZ/jjRrH76q8BXDWgGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072868; c=relaxed/simple;
	bh=+aPAmHsRwIMP3cUP30vvSuAExA7JOO4Z6mYZ2xbqsAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lz2WQ2Qmt92wxPeC6bCeyHF/SJaRX0z3XzwPFAvzoNUs6kqtlXnKuJAJQ4GHDWtDI7312WDcASzZI3J1LKJC+/HTjybvzfyhTXvxAdAterxQZZ2Uug/f7B26n6Yo+0AjtqebtbXpeBy7NNzFDcfoyKXguMCII7WqAnxFa1sPUck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPMyTDSs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPMyTDSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317F1C4CEE7;
	Mon, 12 May 2025 18:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072867;
	bh=+aPAmHsRwIMP3cUP30vvSuAExA7JOO4Z6mYZ2xbqsAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPMyTDSs0tEQ1KCcdMu2Wkgi4Oi5EGAVNtJAbhVZxLhQyRXvqTROOpqmOWaECUebj
	 N4ip+AD/66/U71KUTn/m7VxHqEPipH+fUn/Zwn4k0I4y6tWY/788Qhc2+AZJQcL4/m
	 6KkaO9sritsELQkpyB3IlAoVflzvLtI7Ud7kumG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.12 080/184] drm/amd/display: Shift DMUB AUX reply command if necessary
Date: Mon, 12 May 2025 19:44:41 +0200
Message-ID: <20250512172045.079420904@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <Wayne.Lin@amd.com>

commit 5a3846648c0523fd850b7f0aec78c0139453ab8b upstream.

[Why]
Defined value of dmub AUX reply command field get updated but didn't
adjust dm receiving side accordingly.

[How]
Check the received reply command value to see if it's updated version
or not. Adjust it if necessary.

Fixes: ead08b95fa50 ("drm/amd/display: Fix race condition in DPIA AUX transfer")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d5c9ade755a9afa210840708a12a8f44c0d532f4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -12535,8 +12535,11 @@ int amdgpu_dm_process_dmub_aux_transfer_
 		goto out;
 	}
 
+	payload->reply[0] = adev->dm.dmub_notify->aux_reply.command & 0xF;
+	if (adev->dm.dmub_notify->aux_reply.command & 0xF0)
+		/* The reply is stored in the top nibble of the command. */
+		payload->reply[0] = (adev->dm.dmub_notify->aux_reply.command >> 4) & 0xF;
 
-	payload->reply[0] = adev->dm.dmub_notify->aux_reply.command;
 	if (!payload->write && p_notify->aux_reply.length &&
 			(payload->reply[0] == AUX_TRANSACTION_REPLY_AUX_ACK)) {
 


