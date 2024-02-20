Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1D2612D7;
	Tue, 20 Feb 2024 21:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463470; cv=none; b=aPp//PsEaNnSM1BbRoHvoQm9AL7ldaO2syGTSNJQCGbNJuMDSIkz5VYvZpcirHKVH/C1UjJLCRA3N8zHkhWu7/NN6kZY96NubQ1Iz66JIJ2d+JZn5w+utWhMc5XDmhBFjWNrPGG0TIJ6cBxlUmPL0Ww2tmNPr8z0HjuWPZLkOKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463470; c=relaxed/simple;
	bh=EzghjXfjNAaEV+ezgoYqXjZvn4nprKm+/9RPdNWsuAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eq7W2XvSN394Kh62Q6iFZO2ucYxFpe76yCataYR24CQFRHhuO2l+XlV8IC30Cs63b9l3vNbiWAT7UjXCll43ZxVEIP5nRvyCwEQVJFRqEryosXBdvVbvy65nzzieHnWcdjf40JnTPd0BhoaCtQaJ13a2YPpWJh+jvozrrxAF984=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pATganJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pATganJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB094C433C7;
	Tue, 20 Feb 2024 21:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463470;
	bh=EzghjXfjNAaEV+ezgoYqXjZvn4nprKm+/9RPdNWsuAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pATganJco+Jg6QIDQ9R0WU8iCw5jUqkCamZq8hkVS+bzL/pDdBKzVkQ2v+5OgGnAu
	 C4VNue+l63OHsCRAfgP8RvtYJbICsRSXdJSMQU/HKb1STOEXJHc7Gez9mVlXlWDobd
	 v/etv4eBFm1D9701jIj0rB8Bmg2fJYgmL9QvdKI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/331] devlink: Fix command annotation documentation
Date: Tue, 20 Feb 2024 21:52:21 +0100
Message-ID: <20240220205638.382509382@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 4ab18af47a2c2a80ac11674122935700caf80cc6 ]

Command example string is not read as command.
Fix command annotation.

Fixes: a8ce7b26a51e ("devlink: Expose port function commands to control migratable")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240206161717.466653-1-parav@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/devlink/devlink-port.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index e33ad2401ad7..562f46b41274 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -126,7 +126,7 @@ Users may also set the RoCE capability of the function using
 `devlink port function set roce` command.
 
 Users may also set the function as migratable using
-'devlink port function set migratable' command.
+`devlink port function set migratable` command.
 
 Users may also set the IPsec crypto capability of the function using
 `devlink port function set ipsec_crypto` command.
-- 
2.43.0



