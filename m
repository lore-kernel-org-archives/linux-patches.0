Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFE6341660;
	Tue, 26 Aug 2025 13:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215914; cv=none; b=g54dsm8XhXTT+LOSzE0/Je8erHpuuNVGePudgMzPFxu6LZzeCws3TdJmJ1N4jDmNKapWOyEu5flAdtzUXLJpelH9DUUu+ejrJC0pQSvXtkdkHseDqwL5sWBrk1HIgUm3p8233zB7PX4oZdLBGZT5qWx/9cDu//OYe7zKLOrBnqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215914; c=relaxed/simple;
	bh=EMGnNm0wX9+J4iKqWtnU4b+OiEJDQElESWUI7h4kHeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOdh1qsdKCVTlgJ+MdQKqC7HgRaSy4EqGvx+1Rv9Cp94LCmGpKuVSPtep50kHWha35ciJBO64n2aiXQktW7AH+cSuFPnkACrHJaZOVCUzXV229oqiuBuODIOUkKFQoLQ9lIL4DgJI9ufdva1Ee6bs0waWNifGSaz4CXHF39WoY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7Rs7VT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7Rs7VT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5351C4CEF1;
	Tue, 26 Aug 2025 13:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215914;
	bh=EMGnNm0wX9+J4iKqWtnU4b+OiEJDQElESWUI7h4kHeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7Rs7VT/oQu+2deGqOC0OtG+TamlBYg6smVQyRJbZTMxI0m06dxGfxPqVVnGdyc1E
	 vQAqA6C3CWEmvIeTL6VsrKGD6lHNPkE6fu9S2ZJrCZjFE3hCwl9zhyrhhT3MTXzNas
	 r4uF+TZXEKEaa++SNr/vsfT9kWzaRm5KsMW9WKhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 213/644] f2fs: doc: fix wrong quota mount option description
Date: Tue, 26 Aug 2025 13:05:04 +0200
Message-ID: <20250826110951.712843703@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 81b6ecca2f15922e8d653dc037df5871e754be6e ]

We should use "{usr,grp,prj}jquota=" to disable journaled quota,
rather than using off{usr,grp,prj}jquota.

Fixes: 4b2414d04e99 ("f2fs: support journalled quota")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/f2fs.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/f2fs.rst b/Documentation/filesystems/f2fs.rst
index 7fe50b0bccde..f3e9ba8d6892 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -211,9 +211,9 @@ usrjquota=<file>	 Appoint specified file and type during mount, so that quota
 grpjquota=<file>	 information can be properly updated during recovery flow,
 prjjquota=<file>	 <quota file>: must be in root directory;
 jqfmt=<quota type>	 <quota type>: [vfsold,vfsv0,vfsv1].
-offusrjquota		 Turn off user journalled quota.
-offgrpjquota		 Turn off group journalled quota.
-offprjjquota		 Turn off project journalled quota.
+usrjquota=		 Turn off user journalled quota.
+grpjquota=		 Turn off group journalled quota.
+prjjquota=		 Turn off project journalled quota.
 quota			 Enable plain user disk quota accounting.
 noquota			 Disable all plain disk quota option.
 whint_mode=%s		 Control which write hints are passed down to block
-- 
2.39.5



