Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97633BFE52;
	Thu, 15 Jan 2026 17:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497292; cv=none; b=D7h3C7n841gyOmkS7MwVduRBQ9ZrIgoVQZsrxHSjsNbyOFd+a6h0sXUoX8tKQGIJP8691CByt/OftCqGgpQmLLHA1lccItBUJoryutap4QjGZgWkmBoJIHpBDe9kmZI3Oj9wReQEcrII7dMDIIhaRe9gsp/Tt4tfjqOrkpbNhTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497292; c=relaxed/simple;
	bh=AT+h96NqDMgC/70wv9tDmxUREBMMyMAZYzyHuXm509k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJiXbRZvfz4E8pbDRIVVmJ29DsPpAKTrRcdw/FbSBG5TaC4Oe9q1LsKwh47mgg5aYDp+uF6c4dEQAN/2ujaRQRTu0QZQnBJ6yxcvMcPPxVD/0LCAKYXUw2h4ZAmsaecSdLde5NFnzGz2kCWinAV3ZBhDqYgAy2QYx1m8LBbENmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XX1n80hS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XX1n80hS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6E6C19422;
	Thu, 15 Jan 2026 17:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497292;
	bh=AT+h96NqDMgC/70wv9tDmxUREBMMyMAZYzyHuXm509k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XX1n80hSvbHXaI2StN009pysujDdkthVomzrdRiu0IdXPrIsIarvlFi4nrXV81dJF
	 5rni6D24CowqcR78uikjGloV0xPxfofxI6IUo4w7/JBh7CyQ4YMCm7T9Muw8lHL6jQ
	 zEzAsmxn/MszhFqUAw/rfcDcSur83ttASWAtpTlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.15 009/554] Documentation: process: Also mention Sasha Levin as stable tree maintainer
Date: Thu, 15 Jan 2026 17:41:15 +0100
Message-ID: <20260115164246.575536633@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


