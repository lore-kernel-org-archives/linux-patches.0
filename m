Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585455;
	b=MQvuJXgALoVrD3IkAG5+eHxDqLmpJCXr30MruXsxRhQsfRxSOQiTRgy29Uo7FqJasBLf
	 Se/OsNiGBUIvcuvIbFZxwfJhpwLtJQSu756TupqCDkittpeQvLNpbcH8M+NGo5IcnvEvP
	 WgqI1nS5PgZtYVE8BvNoLS2DPotQ59Dvfy/M9vkO0iA6J+1y1P3ZamVlUs0iKry/Ju9a0
	 uTv2Pr5rYkTpxd5iA52/Qmo5b08QF4X0se+OCeU396KUifxBy3f+7RO0UTBZ0MQC8h1aJ
	 qs2OwflbwNtRAtIiOj/maBrun6Sa6t+u3p/N1foeS4AQuw/ObhpBuCfRvakZSTlx46g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t8U1K0Ik18Dwfx9SDh/NivbKonv6hbOfQm0OyuaBaH8=;
	b=AY+TXoUQ2cklZ8nmo5ovjH8mB6DcNOTezWF8MWszfEaN5j3JwTfM/MPQfsNL+6KH7JR+
	 1KN8h3IpVFwmC9bgodNHNXm425EvfkRyx2/hkgne+12RKAAXiW78m/O7bGxl6xk4y3Zi4
	 wtQs6iK4DANJ8DGdcmL6pcpbX/3I69vY9Rjp/3MZyoMxhtX3skQo/QD9/oS45rCDR02HX
	 YmtO5PUATUzRi0sieDiPxkB5lZ1BZIm3HmiDjMm4nxCtXRpGICfTY0fYxJEW3S3tQeoS4
	 wJYL21fjxgq7/IUExUq10mbzmciskU0xpvpxyiw299HiRhxM7qpjJv5vMaI9An9hKVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xF582M+F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A355C60A6F43;
	Fri, 13 Nov 2026 15:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xF582M+F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5AD1F000C4;
	Fri, 13 Nov 2026 15:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585455;
	bh=t8U1K0Ik18Dwfx9SDh/NivbKonv6hbOfQm0OyuaBaH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xF582M+F0x+NvTRYcbCbqDRmHXTZYFgcWlN3R//p5keWbC6vyQF+TQuha0T/D7iwx
	 ikm+uTE1lJDp3ctvJrkPjAW+tnoo4YwUMf9ubBy1GDcyvwDx5m8xEMZwmlw1/cbyJj
	 YDhMGPumFNlf8ltBKvGwxn4GPIZRFNgt8iM/8xCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Blessed Kimani <jackblessed191@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 114/507] ksmbd: fix NULL pointer dereference in session_user_name() and session_account_type()
Date: Fri, 13 Nov 2026 10:46:58 -0500
Message-ID: <20261113153758.207586208@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Blessed Kimani <jackblessed191@gmail.com>

[ Upstream commit d13da43938d15b0b719827d8f2b32df8eaec5def ]

session_user_name() and session_account_type() dereference
session->user without checking for NULL. A session can be published
and exposed via the procfs session interface before authentication
completes, during which session->user is NULL:

  show_proc_session() -> session_user_name(sess)
    -> user_guest(session->user) -> NULL->flags -> oops

Guard both functions by treating a NULL session->user as an explicit
not-yet-authenticated state rather than dereferencing it.

Fixes: 1f7dd03a88a8 ("ksmbd: fix malformed procfs status output")
Cc: stable@vger.kernel.org
Signed-off-by: Jack Blessed Kimani <jackblessed191@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_session.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 1b30e432ebfd8..d131809dd08ad 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -89,6 +89,8 @@ static const char *session_state_string(struct ksmbd_session *session)
 
 static const char *session_user_name(struct ksmbd_session *session)
 {
+	if (!session->user)
+		return "(Unauthenticated)";
 	if (user_guest(session->user))
 		return "(Guest)";
 	else if (ksmbd_anonymous_user(session->user))
@@ -98,6 +100,8 @@ static const char *session_user_name(struct ksmbd_session *session)
 
 static const char *session_account_type(struct ksmbd_session *session)
 {
+	if (!session->user)
+		return "unauthenticated";
 	if (user_guest(session->user))
 		return "guest";
 	if (ksmbd_anonymous_user(session->user))
-- 
2.53.0



