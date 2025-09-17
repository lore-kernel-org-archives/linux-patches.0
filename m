Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06122323406;
	Wed, 17 Sep 2025 12:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113404; cv=none; b=JbJpgrMa71wGmS59p4FjNc7CTSLX4LTci2mRA4UF/hkvkzucHnAU+fDhAyKaKhDl2Kf+QlhwGwNNeWBIH7sXAnGj29TTxAAhGkRWhote2DY/DkGU3rTMFKLnebzbaIpNRVIQbcWmfUKj8MrhTOSpWXgxSQnB1/Mga6r67I4lJkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113404; c=relaxed/simple;
	bh=NaHMlCTef6N4owQHSYgMw9xv8EBopN9f085Vw3H5Rhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzWqYwaoXmlT1AraE4DZMsLlswDRbreDI3wGTETt2LPfWegvDfNHGVvmzBr8ngyl+/lCthV8ywigfVOvP9e7l/2G6B+mMohfPkwcnDqHTY8QdPwUsGmKEpSqWRJBgW1/hlStJXbCGWOs/+z9CYCUoUM5cU+TtGN2b77ed9hGUGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wh2sJDXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wh2sJDXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE33C4CEF0;
	Wed, 17 Sep 2025 12:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113403;
	bh=NaHMlCTef6N4owQHSYgMw9xv8EBopN9f085Vw3H5Rhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wh2sJDXLEAxaKUz1SIXwM0ZNrJHFEnWOdHowImrLxDcHb+ZI5KFzrzFn/7P46NtN+
	 oJzIFGwhg4wJ2n3dV0WvWI8E3iKmCd+zEQP65f/pl7IEwA9+fOUl7AvPEpuUxEbcmD
	 bi8dETpgiBz1JSE+L8nKDTPJpJDqv7tzMBSEST78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davide Caratti <dcaratti@redhat.com>,
	Donald Hunter <donald.hunter@gmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/140] netlink: specs: mptcp: replace underscores with dashes in names
Date: Wed, 17 Sep 2025 14:34:05 +0200
Message-ID: <20250917123346.094503059@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 9e6dd4c256d0774701637b958ba682eff4991277 ]

We're trying to add a strict regexp for the name format in the spec.
Underscores will not be allowed, dashes should be used instead.
This makes no difference to C (codegen, if used, replaces special
chars in names) but it gives more uniform naming in Python.

Fixes: bc8aeb2045e2 ("Documentation: netlink: add a YAML spec for mptcp")
Reviewed-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250624211002.3475021-8-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7094b84863e5 ("netlink: specs: mptcp: fix if-idx attribute type")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/netlink/specs/mptcp_pm.yaml |    8 ++++----
 include/uapi/linux/mptcp_pm.h             |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/Documentation/netlink/specs/mptcp_pm.yaml
+++ b/Documentation/netlink/specs/mptcp_pm.yaml
@@ -57,21 +57,21 @@ definitions:
       doc: >-
         A new subflow has been established. 'error' should not be set.
         Attributes: token, family, loc_id, rem_id, saddr4 | saddr6, daddr4 |
-        daddr6, sport, dport, backup, if_idx [, error].
+        daddr6, sport, dport, backup, if-idx [, error].
      -
       name: sub-closed
       doc: >-
         A subflow has been closed. An error (copy of sk_err) could be set if an
         error has been detected for this subflow.
         Attributes: token, family, loc_id, rem_id, saddr4 | saddr6, daddr4 |
-        daddr6, sport, dport, backup, if_idx [, error].
+        daddr6, sport, dport, backup, if-idx [, error].
      -
       name: sub-priority
       value: 13
       doc: >-
         The priority of a subflow has changed. 'error' should not be set.
         Attributes: token, family, loc_id, rem_id, saddr4 | saddr6, daddr4 |
-        daddr6, sport, dport, backup, if_idx [, error].
+        daddr6, sport, dport, backup, if-idx [, error].
      -
       name: listener-created
       value: 15
@@ -255,7 +255,7 @@ attribute-sets:
         name: timeout
         type: u32
       -
-        name: if_idx
+        name: if-idx
         type: u32
       -
         name: reset-reason
--- a/include/uapi/linux/mptcp_pm.h
+++ b/include/uapi/linux/mptcp_pm.h
@@ -27,14 +27,14 @@
  *   token, rem_id.
  * @MPTCP_EVENT_SUB_ESTABLISHED: A new subflow has been established. 'error'
  *   should not be set. Attributes: token, family, loc_id, rem_id, saddr4 |
- *   saddr6, daddr4 | daddr6, sport, dport, backup, if_idx [, error].
+ *   saddr6, daddr4 | daddr6, sport, dport, backup, if-idx [, error].
  * @MPTCP_EVENT_SUB_CLOSED: A subflow has been closed. An error (copy of
  *   sk_err) could be set if an error has been detected for this subflow.
  *   Attributes: token, family, loc_id, rem_id, saddr4 | saddr6, daddr4 |
- *   daddr6, sport, dport, backup, if_idx [, error].
+ *   daddr6, sport, dport, backup, if-idx [, error].
  * @MPTCP_EVENT_SUB_PRIORITY: The priority of a subflow has changed. 'error'
  *   should not be set. Attributes: token, family, loc_id, rem_id, saddr4 |
- *   saddr6, daddr4 | daddr6, sport, dport, backup, if_idx [, error].
+ *   saddr6, daddr4 | daddr6, sport, dport, backup, if-idx [, error].
  * @MPTCP_EVENT_LISTENER_CREATED: A new PM listener is created. Attributes:
  *   family, sport, saddr4 | saddr6.
  * @MPTCP_EVENT_LISTENER_CLOSED: A PM listener is closed. Attributes: family,


