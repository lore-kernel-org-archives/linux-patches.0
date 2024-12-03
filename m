Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322331F75B6;
	Tue,  3 Dec 2024 14:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237947; cv=none; b=dZazBfhW+rVXtoShNwUZmXzLO6nZpkTkLJrLxXk1SL+FGhcAMMhjP+uBeDqzyOBdkmVLUCUOQGnAjUxaZqFcb8uFOsJNIw3fCtMR/WhCOWv6KmWYh7K6ZfT0YyG4bcs2FM3Y/i6M77hZocK9X5nLDCDVsNCObaprAKwRJfxo85E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237947; c=relaxed/simple;
	bh=+2gJa02QG78PS+CGeVg4JJAVb/1QxpeblXosFNEV1Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSydhcxrJxsg76oz/2q8q1v4aGDJN1FgDNZ/6e2gFzMjijzwB9yxyNgiPID3p2YXAuZGx1otwOMjNWgjeSIDRBqgVMOAoVvgMO4P7cd05VHO+mIdaDoTuOGo45piGfXP1Qna4dh+TIXUnrNkbVo5pOmP3U5KBa4PzetZp/FTWK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwxd+8eW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwxd+8eW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACD7C4CECF;
	Tue,  3 Dec 2024 14:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237947;
	bh=+2gJa02QG78PS+CGeVg4JJAVb/1QxpeblXosFNEV1Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwxd+8eW1hMNT/PfjAcIR9E2e/fUIAkaOYPfNEut+RxzXvAdfYECI5e2chrecqQux
	 hdJJcE3JXIoOaywzK2MTAIH5q21r5lG7I+zyaAysM9o5TN1gWUH3NkOA+gyF7SHhST
	 rIIAKr8yXpwEOly6YHqnFcec0QM2K/pJDBzRnO8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baruch Siach <baruch@tkos.co.il>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 116/817] doc: rcu: update printed dynticks counter bits
Date: Tue,  3 Dec 2024 15:34:48 +0100
Message-ID: <20241203144000.243470994@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit 4a09e358922381f9b258e863bcd9c910584203b9 ]

The stall warning prints 16 bits since commit 171476775d32
("context_tracking: Convert state to atomic_t").

Fixes: 171476775d32 ("context_tracking: Convert state to atomic_t")
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Reviewed-by: "Paul E. McKenney" <paulmck@kernel.org>
Signed-off-by: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/RCU/stallwarn.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/RCU/stallwarn.rst b/Documentation/RCU/stallwarn.rst
index ca7b7cd806a16..30080ff6f4062 100644
--- a/Documentation/RCU/stallwarn.rst
+++ b/Documentation/RCU/stallwarn.rst
@@ -249,7 +249,7 @@ ticks this GP)" indicates that this CPU has not taken any scheduling-clock
 interrupts during the current stalled grace period.
 
 The "idle=" portion of the message prints the dyntick-idle state.
-The hex number before the first "/" is the low-order 12 bits of the
+The hex number before the first "/" is the low-order 16 bits of the
 dynticks counter, which will have an even-numbered value if the CPU
 is in dyntick-idle mode and an odd-numbered value otherwise.  The hex
 number between the two "/"s is the value of the nesting, which will be
-- 
2.43.0



