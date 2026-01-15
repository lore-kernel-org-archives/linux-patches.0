Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FB61A2389;
	Thu, 15 Jan 2026 17:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498844; cv=none; b=JdFwZssTE3VoSS/gBvq7MaPHtuZ4ypKBS00FeLor1cqOTm9q6ApZgLnVqZsOlGGms1h0s00ERM2vxB5LluURc62yQKQ24gykggOhqyTq78Zlgxc6qSYfe8HOpYDf2RU9ccQ4ez3S5Px6ojhESk9uOIp8kk+jaaRK8HkKsFKHJRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498844; c=relaxed/simple;
	bh=2ofqnW618QA5bTuvQrVU6lGmkxdVMcjBzSDLK0/uvVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmVu0fslrdPEiKeaWK/EI4eIhE6xsQsytDgpg5we7qJiLNC9FGcyvWErBO2VVXPKsoZOMLvfN0vsfVyZaqTyGGjSUMh+aZVzZIvJgbnuVmUAqCzb+3rJVXUtdRqnl51+EVIZlDJ6O5bs/Fw+RZwe2xC5A4OGFqFi/g1Se9GdcR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmsyVB8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmsyVB8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0081C116D0;
	Thu, 15 Jan 2026 17:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498844;
	bh=2ofqnW618QA5bTuvQrVU6lGmkxdVMcjBzSDLK0/uvVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmsyVB8FyiDyqLJGAPzoFXossidY9wfzAY2tXE6UzBJKRVRBHVARFeXFNe6lhTEnG
	 l2jxgkOMQyrijtnFg1Eq8rjqHhynsegiBVT11beSkhNlsAui6hEwBk0KHPYc+BGI+6
	 s42aF0tEUVycOxzc1PC4Wdszn3LbtUETbmtBDjBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.10 005/451] Documentation: process: Also mention Sasha Levin as stable tree maintainer
Date: Thu, 15 Jan 2026 17:43:26 +0100
Message-ID: <20260115164231.074397464@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


