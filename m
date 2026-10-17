Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2044224D6;
	Sat, 17 Oct 2026 16:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253186; cv=none; b=BHWpqCyzvm5JnDaO4L5wQC0vZILWxq10WBkWZ2IuD55OnYep3ot1t8ywqZtqXSbb7C+miePEyxs63HAPQF2XqS9EyxjlcV0tx38qSbx2PlemajYUQ5tlGB6g4OxxUcxNwErGcWtnwRk89qdqOa1MDHtGAwvepFzJigFGn6lIzUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253186; c=relaxed/simple;
	bh=cNmApeFqtGkRK++rb1j93Szfvg+zdUEWMvYcTWlvwtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6eBJocTujW9yMoy3NKQh4IXowm0jATLaCNdJA1ZPiFWy8BGBCXTmxrtZWbk0hCBPJOAovmRDYuh/Xlt9uM3SMkc8BoMGclag6XeU5CzQpNCsLtOa+u7VTY0z4u8KGekb6yv3Jzct0dElA//HUT22rrTvhtAHgtwYI+OFN5IQ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgL1ymNf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgL1ymNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1421F000C4;
	Sat, 17 Oct 2026 16:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253185;
	bh=/dRgoxm5YItKh4R9nLiHGP0epTeLhZw4GylMlA10RcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lgL1ymNfKeHrc3Te92FPR2n/SIWYBHRuljiQyZgEFhlvj7L4tD9WiYLr8zqHjICls
	 hv+cY3NSPkJluHCnv0HutvDauSxEmP6GmhMT0E1BJxEmjCja7AgQqgeYBv10mGdL5G
	 lFJy9O0L4nEdPrMyZy9eaL8OAIu29/Nera2QMmGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Marc Harvey <marcharvey@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/869] net: team: Remove unused team_mode_op, port_enabled
Date: Sat, 17 Oct 2026 17:47:41 +0200
Message-ID: <20261017160037.527665854@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Harvey <marcharvey@google.com>

[ Upstream commit 014f249121d73909528df320818fba7693d0ec92 ]

This team_mode_op wasn't used by any of the team modes, so remove it.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Marc Harvey <marcharvey@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260409-teaming-driver-internal-v7-2-f47e7589685d@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: b7454f1940c5 ("net: team: stop reusing skb after queue override")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c | 2 --
 include/linux/if_team.h      | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index 3cbaee3ff5fd7..7d14acaadd616 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -944,8 +944,6 @@ static void team_port_enable(struct team *team,
 			   team_port_index_hash(team, port->index));
 	team_adjust_ops(team);
 	team_queue_override_port_add(team, port);
-	if (team->ops.port_enabled)
-		team->ops.port_enabled(team, port);
 	team_notify_peers(team);
 	team_mcast_rejoin(team);
 	team_lower_state_changed(port);
diff --git a/include/linux/if_team.h b/include/linux/if_team.h
index cdc684e04a2fb..31a4f13ab2986 100644
--- a/include/linux/if_team.h
+++ b/include/linux/if_team.h
@@ -121,7 +121,6 @@ struct team_mode_ops {
 	int (*port_enter)(struct team *team, struct team_port *port);
 	void (*port_leave)(struct team *team, struct team_port *port);
 	void (*port_change_dev_addr)(struct team *team, struct team_port *port);
-	void (*port_enabled)(struct team *team, struct team_port *port);
 	void (*port_disabled)(struct team *team, struct team_port *port);
 };
 
-- 
2.53.0



