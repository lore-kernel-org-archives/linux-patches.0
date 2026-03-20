Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DD23B9604;
	Fri, 20 Mar 2026 13:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774012584; cv=none; b=EWZRan5ye1hRHR9a6Icct+kvj26ND3+4W6vBskYpal5JtPzUg99Bh4QQSpp0fDwffNt57RAS6IUJLEyesWFrb27s3TmOOoWtjFg5MkaOyxIUS4YZVdc2M37d5GafkZBfmBAVnCw4J+GWqgCfXZmdD9OT49eEEhbcILJ+adXHduY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774012584; c=relaxed/simple;
	bh=psBMVgv76byQe1HFfS0z712vDXpgLslntH8P3twRIR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IbZVVfGVELX5+6Oc1J8c21KTVwvqYNBkJbpqXba/PIEr+jb2wgacB5LF94l09pYxDbtp5K11j+IIKelvbZufFGDzob7dfyGmQe4iiVtLqvBqGuPPM4N3Y0X6AyYITIP9gApG9X811coW37gW15IjdnZ45pJMfU+pin4yT7j0zF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=omnhhQ9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="omnhhQ9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F12C4CEF7;
	Fri, 20 Mar 2026 13:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774012583;
	bh=psBMVgv76byQe1HFfS0z712vDXpgLslntH8P3twRIR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omnhhQ9Jj3oQ5rONv68fHVeyY1zc4AX/FXQ3S47ENt57Y5DjuKqtdADGw3lKZMiMk
	 VzGulnCbzqUyaL9Nz9UR92EK5Ap77rSGoyA6vShmrp2RrKi/qpZj756yLFX2XZv5v+
	 GejKoaHAUES7dYoLH/UXU3RP7vSJ5RGx+O5coCicvWHhm4JcHKweMcjeM8oB+P9ACn
	 XnB1HWCx1lSb+x6Uk+IHI1FWtwIvFzzaQ7DvzoHysfBmRuL7FEklgHLy1jdrU4U2+f
	 29QwJC0ENasx+F5wQ+0tw1lM855CS0RFuZEKlS+eDx56S1EJ8OJVDAcPvq89HQUkZL
	 ReADJAsuToJSw==
From: Christian Brauner <brauner@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	patches@lists.linux.dev,
	kernel-janitors@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init/initramfs.c: trivial fix: FSM -> Finite-state machine
Date: Fri, 20 Mar 2026 14:16:13 +0100
Message-ID: <20260320-geeilt-westufer-4ed00f188709@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319232721.452950-1-safinaskar@gmail.com>
References: <20260319232721.452950-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=923; i=brauner@kernel.org; h=from:subject:message-id; bh=psBMVgv76byQe1HFfS0z712vDXpgLslntH8P3twRIR8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTu9VhUnctiusHpTeAbq50al2ZlmLUvfNRuOnvDzYrFw fvybBhvdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwkk5vhn2UAb/7ZoJ5Cj8nZ eiIOBk/nLHm1bXPohTnP6i5msl5pTWT4K7n+UZIK1y6Oh2zs/pWhYjx+2qYcfyd2Mz1gXRv6sKa WCwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Thu, 19 Mar 2026 23:27:21 +0000, Askar Safin wrote:
> FSM means "finite-state machine", but I think this is not obvious to
> everyone.

Applied to the vfs-7.1.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.1.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.1.misc

[1/1] init/initramfs.c: trivial fix: FSM -> Finite-state machine
      https://git.kernel.org/vfs/vfs/c/49e64d713636
