Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463A0219303;
	Tue,  2 Jun 2026 13:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780406230; cv=none; b=ev9ECc04MHfwBSdYbMeUZyea88fH3O5mH6LOxNi3vr3x4F2n0af9/UF0qxBk0dy29ha5FeaU/Aw/EEmqy4TxMbDaQBfjqM9lmUi2+0ggH8NIbIxikE0HbpVSoOhbyCAp8VZcYGAS++2aApFbOkTYTu5R+zgEuwNA4EIg3RFQciU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780406230; c=relaxed/simple;
	bh=pv0ccRbUlFd7UzDDwsvJdcTrldXAWEKe60nLCXs3PBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tEt4ZdNn8aEee4sVfEbXoJcTK8JiACj5E50NWgWDzm9ozxhJa8QgSytOcX//AT7l4+aQM7CKLfbpjDci7dDHFF+g8dcPsJ9qDAFNJdqHErzdBtHbcXsai7T/8Ed3WgFdfGPeIECJ/LhzBRo5oSIoij+zRGaZP55iwvEcEroyMEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/5H3ObN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/5H3ObN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E00D1F00893;
	Tue,  2 Jun 2026 13:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780406229;
	bh=chx4TDQlPG/cOKsaz8RSYtW/SkbbWLvNfKmDplsGi2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/5H3ObN+93mRzmsCouXFl8XW+l7YSraCoSJltuIhWN5vZ26mNwM50cFyrKSShAVr
	 rXu5apqQHL8gd/okx6bHuLZcUQHMNvdyCx62SjQfpfk9BD1IL01T20XzUI/VPMM9bF
	 5xFCCFYMYUy+HxtwqQLtbdM5HfUOgRyMXtxv0H6/g62vTIdjpewmztHlZ0QAXli4dQ
	 lP5+XxAPhqvdrzll4kOfHZNcTATkQaIdkqtnVBeg0XoQW5hKS5fpFLZwDayrhE/iY8
	 zu/5b3wF3R1KCdh1TzRVdlIkxIkbOLW/DEm3NRaME/5Faeb04i128QZbH8AQHCNnUh
	 7jWjDppGrHjOQ==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org,
	Askar Safin <safinaskar@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	patches@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] include/linux/splice.h: trivial fix: declerations -> declarations
Date: Tue,  2 Jun 2026 15:17:04 +0200
Message-ID: <20260602-lastzug-baumwipfel-dorffest-5d4b7de69132@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260529225813.546405-1-safinaskar@gmail.com>
References: <20260529225813.546405-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=902; i=brauner@kernel.org; h=from:subject:message-id; bh=pv0ccRbUlFd7UzDDwsvJdcTrldXAWEKe60nLCXs3PBQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTJXb+Q4hvsMClbR8pYKz/uerDiiSfXbD3e7Fh6dNcJ6 zt7G9w9OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbydwMjQ5PQTelJd19bTFqm cFnvU+E1htbloZPqzs3/Jx0fJXX0iA7D/6y002FXd7MtncEZ7jq31Ukp5tWyyPjJhqJVF88enPT uPzMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Fri, 29 May 2026 22:58:13 +0000, Askar Safin wrote:
> Trivial fix: declerations -> declarations

Applied to the vfs-7.2.vmsplice branch of the vfs/vfs.git tree.
Patches in the vfs-7.2.vmsplice branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.2.vmsplice

[1/1] include/linux/splice.h: trivial fix: declerations -> declarations
      https://git.kernel.org/vfs/vfs/c/8d86fcfc2857
