Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D29132FA3D;
	Fri,  9 Jan 2026 11:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959396; cv=none; b=DYxuSW6WAsqddrhKN5gIwtdYRuV4z8wJ6z3Bt6SLFkghQnSajg3lCr0QOGi9lRSERmRTWK1/NXC8xnP+ovG5OEYhNnSNQdC6LtjueuxlWtX0rAHCHFo7MJINucxbTRWfDNX+buqT3dBSVgLKgIkuF6CWd8HMTKuxId8zdmT+PW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959396; c=relaxed/simple;
	bh=rtVIecRrTS9vx7Zs3B2HNVzqnP/9msRl3LnPY0xEJA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKCXbg8b3aL9gLit0ablj77lI4zmH8dTmnRMUNOBU0yd298UwRbo33VNDfyDAHNLj5TB3M49xpGAUVYP9K7bU3dpMshY/v5ZF25VyuqjZRVq8oGdZ25W7/Iy4WAaE7+QgWOSoy9NBQFgLRy9hdOkQcAim+iAcog98LkYe5WnMoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oe5dclKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oe5dclKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93373C4CEF1;
	Fri,  9 Jan 2026 11:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959395;
	bh=rtVIecRrTS9vx7Zs3B2HNVzqnP/9msRl3LnPY0xEJA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oe5dclKpNR6C8kkYoulePwxndP5N6NIw88KIZ7Mx3oTObGwxZK6fQ3euMvjwmU+nG
	 s+GsjXL5fa9mZuKlDyIyq9cZYqUVWh0xtEH7szrImgTBOjZJrQN5MGUrYtx0ulyYoT
	 6gPMzRddKkW9BogHqbkIr04tBLqEvVW74YCWXWiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.6 006/737] Documentation: process: Also mention Sasha Levin as stable tree maintainer
Date: Fri,  9 Jan 2026 12:32:25 +0100
Message-ID: <20260109112134.230556004@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bagas Sanjaya <bagasdotme@gmail.com>

commit ba2457109d5b47a90fe565b39524f7225fc23e60 upstream.

Sasha has also maintaining stable branch in conjunction with Greg
since cb5d21946d2a2f ("MAINTAINERS: Add Sasha as a stable branch
maintainer"). Mention him in 2.Process.rst.

Cc: stable@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20251022034336.22839-1-bagasdotme@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/process/2.Process.rst |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/process/2.Process.rst
+++ b/Documentation/process/2.Process.rst
@@ -104,8 +104,10 @@ kernels go out with a handful of known r
 of them are serious.
 
 Once a stable release is made, its ongoing maintenance is passed off to the
-"stable team," currently Greg Kroah-Hartman. The stable team will release
-occasional updates to the stable release using the 5.x.y numbering scheme.
+"stable team," currently consists of Greg Kroah-Hartman and Sasha Levin. The
+stable team will release occasional updates to the stable release using the
+5.x.y numbering scheme.
+
 To be considered for an update release, a patch must (1) fix a significant
 bug, and (2) already be merged into the mainline for the next development
 kernel. Kernels will typically receive stable updates for a little more


