Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744C915ADB4;
	Fri,  9 Jan 2026 12:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961486; cv=none; b=RRzS9DLd0uTYK1r/T/UuDAUYHRnsGPB66CETGkxgF1UF2DRl44QqvS5BHfGq66y+0Ncy/SnEjuBj7v4om8c+eeLw/6GMF8zG5eKN4BIdMmMvuwSsIkC/t/edYDUfbzJSJe2wPCKd9cwzRUIYIvoRe9+92LB45F/ta33d5KwspZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961486; c=relaxed/simple;
	bh=J/A+6SCiALMLnVxU/9uW6PyCA2ghaI056K72oITMquI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRslqKlUgAsuHZNdILles2c4aoMbdrtLkucnKuwKZ1k+K/taKQN1stj7Z4WoiWttNXw6w4eMWkqJsv5hx6DE3SEkLO5Ayb7iahxZCsPZOCpr4D5S3JcoCeBPBOVNS0MXimRCncCtJ5AherrnQNkKYmRHOsTiUTGA4lmicvY3EiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVt91s8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVt91s8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D0BC4CEF1;
	Fri,  9 Jan 2026 12:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961486;
	bh=J/A+6SCiALMLnVxU/9uW6PyCA2ghaI056K72oITMquI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVt91s8d1LadCP2wA3tTFf58b2EXnvk3fxHkX8naThgJSfm60gv67qhkZaxx81FSw
	 YfO95DmWjAy3ylZrGwxKIw2rvArDEX21NIO45+D5R/OS7pEo3Yx/Mdm1hOZcPz1MPl
	 A7F0XjnfjXk88TmxcoUPQXYY8BCg7Mcr8aguINo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.1 007/634] Documentation: process: Also mention Sasha Levin as stable tree maintainer
Date: Fri,  9 Jan 2026 12:34:45 +0100
Message-ID: <20260109112117.701129968@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


