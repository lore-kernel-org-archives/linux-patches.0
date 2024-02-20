Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B296E14A4E6;
	Tue, 20 Feb 2024 21:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464566; cv=none; b=R7Dt8v9ggg/vbJhCh7dXifJvN7B1DWUVFp1Olg4km3fRn3u9XUUfhE5RiTS4z1qWpFTk0XTfW9MqdrhsNX5y9DCrgHl+v39cyPKBVteAj8Lujl/6tnEMNJa1iZFU39kBu0teCOXlKABgUpW1ja0inFHYenEK22n4QXyCpHEYI8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464566; c=relaxed/simple;
	bh=jzJ/WF4DInPYUpCW2yEJnDb9ZgjTci9F3wP0Ev0KVZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtzOB++hJzKj+EIGZMgeDVeayp6XnOSNaPzJUXxRESjk+1iMeTSHEBqk79U/g7H53uLRTdbW0wIBM/QfvdboymbUQdRvlBxviZdAGNeCigjb0jmS2o9bmUtqLSdldmjjWq/iA/JcdoHH865DEiOVw7ZlQO6HWFIzbnHPNeoDfso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEwe+abJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEwe+abJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAE6C433C7;
	Tue, 20 Feb 2024 21:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464566;
	bh=jzJ/WF4DInPYUpCW2yEJnDb9ZgjTci9F3wP0Ev0KVZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEwe+abJrtRShxrI+1EAdEtEm5aO9bfCHLp68PF0Y+KYFcwmwGM6JvFEjmVOF+ABX
	 jkMrtIXY92WWXsokr5tqvItjI2W1LqOop1VUjMVYHEcLJ4HbwCpwtyGFBjS0ubUsBX
	 7ASXbxXEw2RGQLvf4JnQIa6BdAnTpew2Qx8jP28E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 034/309] devlink: Fix command annotation documentation
Date: Tue, 20 Feb 2024 21:53:13 +0100
Message-ID: <20240220205634.252198404@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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



